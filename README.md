# Awesome (Linux amd64) CLI Binaries

> This image builds a static version of tmux and downloads latest Linux amd64
> binaries of popular terminal utilities. Quickly install the newest utilities
> on any Linux server.

## Use-case

Working on many remote servers? Can't install your favorite tools for some
reason? With this repo, you can quickly upload them to a remote Linux server,
together with comfortable pre-made configurations.

## Setup

1. Install [just] on your workstation. (macOS: `brew install just`)

1. Prepare the binaries on your workstation:

    ```sh
    git clone git@github.com/rafi/awesome-cli-binaries.git
    cd awesome-cli-binaries
    ```

1. **Optional:** To speed up things, you can pull the image from Docker Hub:

    ```sh
    docker pull rafib/awesome-cli-binaries
    ```

1. Run `just docker` — this can take time! It builds tmux from source and
   downloads all binaries. (Make sure you have `GITHUB_TOKEN` or
   `HOMEBREW_GITHUB_API_TOKEN` environment variable, set with your token, to
   avoid GitHub's rate-limiting.)

1. Finally, run `just binaries` to copy all binaries from image into `bin/`.

## Provision Remote Node

Use the `setup.sh` helper script to provision servers.

```sh
./setup.sh -h
./setup.sh me@myserver.com [more...]
```

## Sync Binaries

If you just want to update the binaries on remote, run:

```sh
just sync me@myserver.com [more...]
```

This will rsync local binaries at `./bin` to remote `~/.local/bin`.

## Binaries

- [tmux] v3.4 statically linked (+ncurses +libevent)
- [fish] v4
- [neovim] build with support for glibc 2.17
- and:

| Program       | Description   | Screenshot  |
|:------------- |:------------- | -----------:|
| [bandwhich]   | Utility for displaying current network utilization. | <img src="https://github.com/imsnif/bandwhich/raw/main/res/demo.gif" /> |
| [bat]         | A cat(1) clone with syntax highlighting and Git integration. | <img src="https://imgur.com/rGsdnDe.png" /> |
| [btop]        | Resource monitor that shows usage and stats. | <img src="https://raw.githubusercontent.com/aristocratos/btop/main/Img/normal.png" /> |
| [chafa]       | View very reasonable approximations of pictures and animations in the terminal. | <img src="https://hpjansson.org/chafa/gallery/maru-geneve-240-rgb.png" width="60%" /> |
| [crane]       | Crane is a tool for interacting with remote images and registries. | <img src="https://raw.githubusercontent.com/google/go-containerregistry/main/images/crane.png" width="40%" /> |
| [delta]       | Good-lookin' diffs | <img src="https://user-images.githubusercontent.com/52205/86275526-76792100-bba1-11ea-9e78-6be9baa80b29.png" /> |
| [diff-so-fancy] | Syntax-highlighting pager for git, diff, grep, and blame output. | <img src="https://github.com/so-fancy/diff-so-fancy/blob/master/diff-so-fancy.png?raw=true" /> |
| [dua]         | Conveniently learn about the usage of disk space of a given directory. | [![asciicast](https://asciinema.org/a/316444.svg)](https://asciinema.org/a/316444) |
| [duf]         | Disk Usage/Free Utility - a better 'df' alternative. | <img src="https://raw.githubusercontent.com/muesli/duf/master/duf.png" /> |
| [dust]        | A more intuitive version of du in rust. | <img src="https://raw.githubusercontent.com/bootandy/dust/master/media/snap.png" /> |
| [dyff]        | Diff tool for YAML files, and sometimes JSON. | <img src="https://raw.githubusercontent.com/homeport/dyff/main/.docs/dyff-between-kubectl-diff.png" /> |
| [erdtree]     | Modern multi-threaded filesystem and disk-usage analysis tool. | <img src="https://github.com/solidiquis/erdtree/blob/master/assets/top_showcase.png?raw=true" /> |
| [eza]         | A modern alternative to ls | <img src="https://github.com/eza-community/eza/raw/main/docs/images/screenshots.png" /> |
| [fd]          | Simple, fast and user-friendly alternative to `find`. | <img src="https://raw.githubusercontent.com/sharkdp/fd/master/doc/screencast.svg" /> |
| [fx]          | Terminal JSON viewer | <img src="https://medv.io/assets/fx/fx-preview.gif" /> |
| [fzf]         | General-purpose command-line fuzzy finder. | <img src="https://raw.githubusercontent.com/junegunn/i/master/fzf-preview.png" /> |
| [glow]        | Render markdown on the CLI, with pizzazz! | <img src="https://stuff.charm.sh/glow/glow-1.3-trailer-github.gif" /> |
| [hexyl]       | Simple hex viewer for the terminal. | <img src="https://i.imgur.com/MWO9uSL.png" /> |
| [hyperfine]   | A command-line benchmarking tool. | <img src="https://i.imgur.com/z19OYxE.gif" /> |
| [jq]          | Lightweight and flexible command-line JSON processor. | <img src="https://jqlang.github.io/jq/jq.png" width="50%" /> |
| [just]        | Handy way to save and run project-specific commands. | <img src="https://raw.githubusercontent.com/casey/just/master/screenshot.png" /> |
| [lsd]         | Rewrite of GNU `ls` with lots of added features. | <img src="https://raw.githubusercontent.com/Peltoche/lsd/assets/screen_lsd.png" /> |
| [mkcert]      | Make local trusted development certificates with any names you'd like. | <img src="https://user-images.githubusercontent.com/1225294/51066373-96d4aa80-15be-11e9-91e2-f4e44a3a4458.png" /> |
| [ripgrep]     | Line-oriented search tool that recursively searches for a regex pattern. | <img src="https://burntsushi.net/stuff/ripgrep1.png" /> |
| [starship]    | Minimal, blazing-fast, and infinitely customizable prompt for any shell. | <img src="https://raw.githubusercontent.com/starship/starship/master/media/demo.gif" /> |
| [stern]       | Tail multiple pods and containers on Kubernetes. | <img src="https://i0.wp.com/blog.knoldus.com/wp-content/uploads/2021/01/image.png?ssl=1" /> |
| [xh]          | Friendly and fast tool for sending HTTP requests. | [![asciicast](https://raw.githubusercontent.com/ducaale/xh/master/assets/xh-demo.gif)](https://asciinema.org/a/475190) |
| [yazi]        | Blazing fast terminal file manager written in Rust, based on async I/O | <video src="https://yazi-rs.github.io/videos/input_select.mp4" controls="controls" muted="muted" style="max-height:320px; min-height: 200px"></video> |
| [yq]          | Portable command-line YAML, JSON, XML, CSV, TOML and properties processor. | <img src="https://miro.medium.com/v2/resize:fit:640/1*gsqh7A_ivvZM5ht66hx3Xw.png" /> |
| [zoxide]      | zoxide is a **smarter cd command**, inspired by z and autojump. | <img src="https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/contrib/tutorial.webp" /> |

## More

Awesome lists:

- [github.com/alebcay/awesome-shell](https://github.com/alebcay/awesome-shell)
- [github.com/agarrharr/awesome-cli-apps](https://github.com/agarrharr/awesome-cli-apps)

## License

See each program's license.

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
[dyff]: https://github.com/homeport/dyff
[erdtree]: https://github.com/solidiquis/erdtree
[eza]: https://github.com/eza-community/eza
[fd]: https://github.com/sharkdp/fd
[fish]: https://github.com/fish-shell/fish-shell
[fx]: https://github.com/antonmedv/fx
[fzf]: https://github.com/junegunn/fzf
[glow]: https://github.com/charmbracelet/glow
[hexyl]: https://github.com/sharkdp/hexyl
[hyperfine]: https://github.com/sharkdp/hyperfine
[jq]: https://github.com/stedolan/jq
[just]: https://github.com/casey/just
[lsd]: https://github.com/lsd-rs/lsd
[mkcert]: https://github.com/FiloSottile/mkcert
[neovim]: https://github.com/neovim/neovim
[ripgrep]: https://github.com/BurntSushi/ripgrep
[starship]: https://github.com/starship/starship
[stern]: https://github.com/stern/stern
[tmux]: https://github.com/tmux/tmux
[xh]: https://github.com/ducaale/xh
[yazi]: https://github.com/sxyazi/yazi
[yq]: https://github.com/mikefarah/yq
[zoxide]: https://github.com/ajeetdsouza/zoxide
