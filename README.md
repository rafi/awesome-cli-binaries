# Awesome (Linux x86_64) CLI Binaries

> This image builds a static (latest version) of tmux and downloads many linux
> x86_64 binaries of popular terminal utilities. Quickly install the newest
> utilities on any Linux server.

## Utility List

- tmux 3.1c (+ncurses 6.2 +libevent 2.1.12)
- bat 0.17.1
- chafa 1.4.1
- duf 0.4.0
- dyff 1.1.0
- fd 8.2.1
- fzf 0.24.4
- glow 1.1.0
- heksa 1.13.0
- hexyl 0.8.0
- httpiego 0.6.0
- jq 1.6
- kubectl-fuzzy 1.8.0
- lf r17
- mkcert 1.4.1
- ncdu 1.15.1
- reg 0.16.1
- ripgrep 12.1.1
- starship 0.46.2
- stern 1.13.1
- yank 1.2.0
- yj 5.0.0
- zoxide 0.5.0

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
