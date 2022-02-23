# Awesome (Linux x86_64) CLI Binaries

> This image builds a static (latest version) of tmux and downloads many Linux
> x86_64 binaries of popular terminal utilities. Quickly install the newest
> utilities on any Linux server.

## Utility List

- tmux 3.2a (+ncurses 6.2 +libevent 2.1.12)
- bandwhich 0.20.0
- bat 0.19.0
- bottom 0.6.3
- btop 1.2.3
- chafa 1.6.1
- crane 0.8.0
- dua 2.10.9
- duf 0.5.0
- dust 0.7.5
- dyff 1.1.3
- fd 8.3.2
- fzf 0.29.0
- glow 1.4.1
- heksa 1.14.0
- hexyl 0.9.0
- hyperfine 1.11.0
- jless 0.7.2
- jq 1.6
- lf r26
- mkcert 1.4.3
- ncdu 1.15.1
- reg 0.16.1
- ripgrep 13.0.0
- starship 1.3.0
- stern 1.21.0
- yank 1.2.0
- xh 0.13.0
- yj 5.0.0
- zoxide 0.8.0

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
