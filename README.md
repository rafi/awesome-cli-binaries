# Awesome (Linux amd64/arm64) CLI Binaries

[![Docker Pulls](https://img.shields.io/docker/pulls/rafib/awesome-cli-binaries)](https://hub.docker.com/r/rafib/awesome-cli-binaries)
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/rafib/awesome-cli-binaries)](https://hub.docker.com/r/rafib/awesome-cli-binaries)

> Quickly install the newest utilities on Linux amd64/arm64 servers, sudo-less!
> 🚀 🌔
>
> This repository contains a collection of popular CLI utilities:
>
> - [Dockerfile](./Dockerfile) - Builds all binaries statically linked for Linux
>   amd64 and arm64, including latest tmux and fish.
> - [.files](./.files/) - Dotfiles to copy to remote servers.
> - [sync.sh](./sync.sh) - Script to provision remote servers.
>
> Or just browse the [catalog](#binaries)…

## Accompanying Provisioning Script

Use-case: 💡 Working on many remote servers? Can't install your favorite tools
for some reason? With this repo, you can quickly upload them to a remote Linux
server, together with comfortable pre-made configurations.

> [!WARNING]
> [`.files/*`](./.files/) will be copied to the remote server you provision with
> this script, so make sure to backup the remote `~/.config` directory first, if
> there's anything valuable there.

### Option ⟪1⟫ 👾 Provision from Remote

Login and run on **remote server**: (⚠️ READ WARNING ABOVE BEFORE!)

```sh
ssh my-remote-server
curl -sfL init.rafi.io | sh
```

### Option ⟪2⟫ 💻 Provision from Workstation

Prerequisites: Install [just] on your workstation. (macOS: `brew install just`)

```sh
git clone git@github.com/rafi/awesome-cli-binaries.git
cd awesome-cli-binaries

just binaries amd64  # or arm64
./sync.sh me@myserver.com [more...]
```

`just binaries` copies all binaries to local `./bin/` directory, and the
[`sync.sh`](./sync.sh) script provisions the remote server.

### Option ⟪3⟫ 🧰 Copy Only Binaries

If you just want to copy or update the binaries on remote, run:

```sh
just sync me@myserver.com [more...]
```

This will rsync local binaries at `./bin` to remote `~/.local/bin`.

## Binaries

- [tmux] v3.5a statically linked (+ncurses +libevent)
- [fish] v4.8.0
- [neovim] build with support for glibc 2.17
- and:

| Program       | Description   | Screenshot  |
|:------------- |:------------- | -----------:|
| [bandwhich]   | Utility for displaying current network utilization. | <img src="https://github.com/imsnif/bandwhich/raw/main/res/demo.gif" /> |
| [bat]         | A cat(1) clone with syntax highlighting and Git integration. | <img src="https://imgur.com/rGsdnDe.png" /> |
| [btop]        | Resource monitor that shows usage and stats. | <img src="https://raw.githubusercontent.com/aristocratos/btop/main/Img/normal.png" /> |
| [chafa]       | View very reasonable approximations of pictures and animations in the terminal. | <img src="https://hpjansson.org/chafa/gallery/maru-geneve-240-rgb.png" width="60%" /> |
| [crane]       | Crane is a tool for interacting with remote images and registries. | <img src="https://raw.githubusercontent.com/google/go-containerregistry/main/images/crane.png" width="40%" /> |
| [delta]       | Good-lookin' diffs. | <img src="https://user-images.githubusercontent.com/52205/86275526-76792100-bba1-11ea-9e78-6be9baa80b29.png" /> |
| [diff-so-fancy] | Syntax-highlighting pager for git, diff, grep, and blame output. | <img src="https://raw.githubusercontent.com/so-fancy/diff-so-fancy/next/docs/diff-so-fancy.png" /> |
| [dua]         | Conveniently learn about the usage of disk space of a given directory. | [![asciicast](https://asciinema.org/a/316444.svg)](https://asciinema.org/a/316444) |
| [duf]         | Disk Usage/Free Utility - a better 'df' alternative. | <img src="https://raw.githubusercontent.com/muesli/duf/master/duf.png" /> |
| [dust]        | A more intuitive version of du. | <img src="https://raw.githubusercontent.com/bootandy/dust/master/media/snap.png" /> |
| [erdtree]     | Modern multi-threaded filesystem and disk-usage analysis tool. | <img src="https://github.com/solidiquis/erdtree/blob/master/assets/top_showcase.png?raw=true" /> |
| [eza]         | A modern alternative to ls. | <img src="https://github.com/eza-community/eza/raw/main/docs/images/screenshots.png" /> |
| [fd]          | Simple, fast and user-friendly alternative to `find`. | <img src="https://raw.githubusercontent.com/sharkdp/fd/master/doc/screencast.svg" /> |
| [fx]          | Terminal JSON viewer. | <img src="https://medv.io/assets/fx/fx-preview.gif" /> |
| [fzf]         | General-purpose command-line fuzzy finder. | <img src="https://raw.githubusercontent.com/junegunn/i/master/fzf-preview.png" /> |
| [havn]        | Fast configurable port scanner with reasonable defaults. | <img src="https://raw.githubusercontent.com/mrjackwills/havn/main/.github/screen.webp" /> |
| [hexyl]       | Simple hex viewer for the terminal. | <img src="https://i.imgur.com/MWO9uSL.png" /> |
| [hyperfine]   | A command-line benchmarking tool. | <img src="https://i.imgur.com/z19OYxE.gif" /> |
| [jq]          | Lightweight and flexible command-line JSON processor. | <img src="https://camo.githubusercontent.com/b062176121792a6867b2cb9674c4f05d8b63049a8ce83d2c51aa75c4f163604c/68747470733a2f2f696d6775722e636f6d2f656264547456662e706e67" /> |
| [just]        | Handy way to save and run project-specific commands. | <img src="https://raw.githubusercontent.com/casey/just/master/etc/screenshot.png" /> |
| [lsd]         | Rewrite of GNU `ls` with lots of added features. | <img src="https://raw.githubusercontent.com/Peltoche/lsd/assets/screen_lsd.png" /> |
| [rip2]     | Safe and ergonomic alternative to `rm` | |
| [ripgrep]     | Line-oriented search tool that recursively searches for a regex pattern. | <img src="https://burntsushi.net/stuff/ripgrep1.png" /> |
| [starship]    | Minimal, blazing-fast, and infinitely customizable prompt for any shell. | <img src="https://raw.githubusercontent.com/starship/starship/master/media/demo.gif" /> |
| [yazi]        | Blazing fast terminal file manager, based on async I/O. | <img src="https://repository-images.githubusercontent.com/663900193/c1f495b1-8d69-4dba-a7e3-dbfde3a817f6" /> |
| [zoxide]      | zoxide is a smarter cd command, inspired by z and autojump. | <img src="https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/contrib/tutorial.webp" /> |

## More

Awesome lists:

- [github.com/alebcay/awesome-shell](https://github.com/alebcay/awesome-shell)
- [github.com/agarrharr/awesome-cli-apps](https://github.com/agarrharr/awesome-cli-apps)

## License

See [LICENSE.spdx](./LICENSE.spdx) for license information.

[bandwhich]: https://github.com/imsnif/bandwhich
[bat]: https://github.com/sharkdp/bat
[btop]: https://github.com/aristocratos/btop
[chafa]: https://hpjansson.org/chafa
[crane]: https://github.com/google/go-containerregistry
[delta]: https://github.com/dandavison/delta
[diff-so-fancy]: https://github.com/so-fancy/diff-so-fancy
[dua]: https://github.com/Byron/dua-cli
[duf]: https://github.com/muesli/duf
[dust]: https://github.com/bootandy/dust
[erdtree]: https://github.com/solidiquis/erdtree
[eza]: https://github.com/eza-community/eza
[fd]: https://github.com/sharkdp/fd
[fish]: https://github.com/fish-shell/fish-shell
[fx]: https://github.com/antonmedv/fx
[fzf]: https://github.com/junegunn/fzf
[havn]: https://github.com/mrjackwills/havn
[hexyl]: https://github.com/sharkdp/hexyl
[hyperfine]: https://github.com/sharkdp/hyperfine
[jq]: https://github.com/stedolan/jq
[just]: https://github.com/casey/just
[lsd]: https://github.com/lsd-rs/lsd
[neovim]: https://github.com/neovim/neovim
[rip2]: https://github.com/MilesCranmer/rip2
[ripgrep]: https://github.com/BurntSushi/ripgrep
[starship]: https://github.com/starship/starship
[tmux]: https://github.com/tmux/tmux
[yazi]: https://github.com/sxyazi/yazi
[zoxide]: https://github.com/ajeetdsouza/zoxide
