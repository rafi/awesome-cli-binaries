# Awesome (Linux x86_64) CLI Binaries

> This image builds a static (latest version) of tmux and downloads many Linux
> x86_64 binaries of popular terminal utilities. Quickly install the newest
> utilities on any Linux server.

## Utility List

- tmux 3.3a (+ncurses +libevent)
- neovim
- bandwhich
- bat
- bottom
- btop
- chafa
- crane
- dua
- duf
- dust
- dyff
- fd
- fzf
- glow
- hexyl
- hyperfine
- jless
- jq
- lf
- mkcert
- ncdu
- reg
- ripgrep
- starship
- stern
- yank
- xh
- yj
- yq
- zoxide

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
