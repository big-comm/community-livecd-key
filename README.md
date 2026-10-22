# community-livecd-key

The pacman keyring of the BigCommunity live session, ready to use.

> [!WARNING]
> Only for the ISO build. Do not install it on a regular system: it overwrites
> `/etc/pacman.d/gnupg/pubring.gpg` and `trustdb.gpg` with its own copy.

## Why

A live session starts with an empty pacman keyring, and building one with
`pacman-key --init` and `--populate` on every boot is slow and needs every
keyring package installed. This package ships the keyring already built and
trusted, so the live session can verify packages (Calamares installing the
system, or `pacman -S` in the live session) as soon as it boots.

## What it installs

| Path | What |
|---|---|
| `/usr/share/pacman/keyrings/pubring.gpg` | the public keys |
| `/usr/share/pacman/keyrings/trustdb.gpg` | their trust |
| `/usr/bin/community-livecd-key.sh` | copies both into `/etc/pacman.d/gnupg/` and runs `pacman-key --init` |
| `/usr/lib/systemd/system/community-livecd-key.service` | runs that script at boot, after `pacman-init.service` |

The install and upgrade scripts of the package do the same copy once.

## How the keyring is built

The [Update Key](.github/workflows/update-key.yml) workflow runs every
Wednesday at 23:00 UTC, on every push, and by hand (*Run workflow*). It:

1. builds the latest pacman release on the runner;
2. collects the keyrings of every repository a BigCommunity system uses:
   - Arch Linux: `archlinux-keyring`, from archlinux.org;
   - Manjaro: `manjaro-keyring`, from Manjaro's mirror (`mirrors.manjaro.org`);
   - BigLinux: [biglinux-keyring](https://github.com/biglinux/biglinux-keyring);
   - BigCommunity: [community-keyring](https://github.com/big-comm/community-keyring);
3. runs `pacman-key --init` and `pacman-key --populate archlinux manjaro biglinux community`;
4. commits the resulting `pubring.gpg` and `trustdb.gpg` here;
5. asks [big-comm/build-package](https://github.com/big-comm/build-package) to
   build and publish the package in `community-stable`.

A key added to one of those keyrings reaches the next ISO without any change
here: the next run picks it up.

## License

MIT.
