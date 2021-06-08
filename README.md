# Awesome (Linux x86_64) CLI Binaries

> This image builds a static (latest version) of tmux and downloads many linux
> x86_64 binaries of popular terminal utilities. Quickly install the newest
> utilities on any Linux server.

## Utility List

- tmux 3.2 (+ncurses 6.2 +libevent 2.1.12)
- bandwidth 0.20.0
- bat 0.18.1
- chafa 1.6.1
- dua 2.10.7
- duf 0.4.0
- dyff 1.1.0
- fd 8.2.1
- fzf 0.27.2
- glow 1.4.1
- heksa 1.14.0
- hexyl 0.8.0
- httpiego 0.6.0
- hyperfine 1.11.0
- jq 1.6
- lf r22
- mkcert 1.4.1
- ncdu 1.15.1
- reg 0.16.1
- ripgrep 12.1.1
- starship 0.54.0
- stern 1.18.0
- yank 1.2.0
- yj 5.0.0
- zoxide 0.7.0

## Install

### Pull or Build

To speed up things, you can pull the image from Docker Hub:

```sh
docker pull rafib/awesome-cli-binaries
```

**Otherwise**, when running `make` in the next step, image will be built.

### Extract Binaries

Simply run `make` and all binaries should be copied to `./bin/`

```sh
git clone git@github.com/rafi/awesome-cli-binaries.git
cd awesome-cli-binaries
make
```

### Remote Copy (.files/.bin)

Use the `setup.sh` helper script to provision servers.

```sh
./setup.sh -h
./setup.sh --root <ssh-server-address>
```

## TODO

- [ ] neovim
- [ ] tmux-mem-cpu-load
- [ ] tmuxp
- [ ] colordiff / icdiff
- [ ] atool
- [ ] complete-alias
- [ ] diff-so-fancy
- [ ] fx
- [ ] fz
- [ ] grc
- [ ] grv
- [ ] jsonlint
- [ ] media-info
- [ ] p7zip
- [ ] shellcheck
- [ ] siege
- [ ] trash-cli
- [ ] ttyd
- [ ] yamllint

## License

See each program's license.
