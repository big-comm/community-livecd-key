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

Installing or upgrading the package runs the same script once.

## How the keyring is built

The [Update Key](.github/workflows/update-key.yml) workflow runs every
Wednesday at 23:00 UTC, on every push, and by hand (*Run workflow*). In a
`manjarolinux/base` container it:

1. installs `archlinux-keyring` and `manjaro-keyring` from Manjaro's
   repositories, and the keys of
   [biglinux-keyring](https://github.com/biglinux/biglinux-keyring) and
   [community-keyring](https://github.com/big-comm/community-keyring);
2. runs `pacman-key --init` and
   `pacman-key --populate archlinux manjaro biglinux community`, and checks that
   the BigLinux (`F7EB9C2849EFFEFF05789738047C6A782618D2CA`) and BigCommunity
   (`AECEEE84E52BBFAA9F1C9DF01EA0CEEEB09B44A3`) signing keys are there;
3. commits `pubring.gpg` and `trustdb.gpg` when they changed;
4. asks [big-comm/build-package](https://github.com/big-comm/build-package)
   to build and publish the package in `community-stable`. The weekly run
   builds only when the keyring changed.

A key added to one of those keyrings reaches the next ISO without any change
here: the next run picks it up.

The build request uses the repository secret `REPOSITORY_TOKEN`: a GitHub
token that can start workflows in `big-comm/build-package`.

## License

MIT.
