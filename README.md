# Awesome (Linux x86_64) CLI Binaries

> This image builds a static (latest version) of tmux and downloads many Linux
> x86_64 binaries of popular terminal utilities. Quickly install the newest
> utilities on any Linux server.

## Utility List

- tmux 3.3a (+ncurses 6.2 +libevent 2.1.12)
- neovim 0.7.0
- bandwhich 0.20.0
- bat 0.22.1
- bottom 0.6.3
- btop 1.2.6
- chafa 1.10.3
- crane 0.12.1
- dua 2.10.9
- duf 0.5.0
- dust 0.7.5
- dyff 1.1.3
- fd 8.6.0
- fzf 0.35.1
- glow 1.4.1
- hexyl 0.12.0
- hyperfine 1.11.0
- jless 0.8.0
- jq 1.6
- lf r27
- mkcert 1.4.3
- ncdu 1.15.1
- reg 0.16.1
- ripgrep 13.0.0
- starship 1.6.3
- stern 1.22.0
- yank 1.2.0
- xh 0.13.0
- yj 5.1.0
- yq 4.30.5
- zoxide 0.8.3

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
