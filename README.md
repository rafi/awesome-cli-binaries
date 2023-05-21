# Awesome (Linux x86_64) CLI Binaries

> This image builds a static latest version of tmux and downloads Linux x86_64
> binaries of popular terminal utilities. Quickly install the newest utilities
> on any Linux server.

## Use-case

Working on different remote servers? Annoyed your tools aren't there? With
this repo, you can quickly upload them to a Linux remote server, including
a spiffy bash config.

## Setup

1. Install [just](https://github.com/casey/just) on your workstation.

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
   downloads all binaries into `bin/`.

## Provision Remote Node

Use the `setup.sh` helper script to provision servers.

```sh
./setup.sh -h
./setup.sh <ssh-server-address>
```

## Binaries

- [tmux] statically linked (+ncurses +libevent)
- [neovim] (appimage)
- and:

| Program       | Description   |             |
|:------------- |:------------- | -----------:|
| [bandwhich]   | Utility for displaying current network utilization by process, connection and remote IP/hostname. | <img src="https://raw.githubusercontent.com/imsnif/bandwhich/main/demo.gif" /> |
| [bat]         | A cat(1) clone with syntax highlighting and Git integration. | <img src="https://imgur.com/rGsdnDe.png" /> |
| [bottom]      | A customizable cross-platform graphical process/system monitor for the terminal. | <img src="https://raw.githubusercontent.com/ClementTsang/bottom/master/assets/demo.gif" /> |
| [btop]        | Resource monitor that shows usage and stats for processor, memory, disks, network and processes. | <img src="https://raw.githubusercontent.com/aristocratos/btop/main/Img/normal.png" /> |
| [chafa]       | View very reasonable approximations of pictures and animations in the terminal. | <img src="https://hpjansson.org/chafa/gallery/maru-geneve-240-rgb.png" width="60%" /> |
| [crane]       | Crane is a tool for interacting with remote images and registries. | <img src="https://raw.githubusercontent.com/google/go-containerregistry/main/images/crane.png" width="40%" /> |
| [dua]         | Disk Usage Analyzer is a tool to conveniently learn about the usage of disk space of a given directory. | [![asciicast](https://asciinema.org/a/316444.svg)](https://asciinema.org/a/316444) |
| [duf]         | Disk Usage/Free Utility - a better 'df' alternative. | <img src="https://raw.githubusercontent.com/muesli/duf/master/duf.png" /> |
| [dust]        | A more intuitive version of du in rust. | <img src="https://raw.githubusercontent.com/bootandy/dust/master/media/snap.png" /> |
| [dyff]        | /ˈdʏf/ - diff tool for YAML files, and sometimes JSON. | <img src="https://raw.githubusercontent.com/homeport/dyff/main/.docs/dyff-between-kubectl-diff.png" /> |
| [erdtree]     | Modern multi-threaded filesystem and disk-usage analysis tool. | <img src="https://github.com/solidiquis/erdtree/raw/master/assets/showcase_top.png?raw=true" /> |
| [fd]          | Find entries in your filesystem. It is a simple, fast and user-friendly alternative to `find`. | <img src="https://raw.githubusercontent.com/sharkdp/fd/master/doc/screencast.svg" /> |
| [fzf]         | General-purpose command-line fuzzy finder. | <img src="https://raw.githubusercontent.com/junegunn/i/master/fzf-preview.png" /> |
| [glow]        | Render markdown on the CLI, with pizzazz! | <img src="https://stuff.charm.sh/glow/glow-1.3-trailer-github.gif" /> |
| [hexyl]       | Simple hex viewer for the terminal. It uses a colored output to distinguish different categories of bytes. | <img src="https://i.imgur.com/MWO9uSL.png" /> |
| [hyperfine]   | A command-line benchmarking tool. | <img src="https://i.imgur.com/z19OYxE.gif" /> |
| [jless]       | Command-line JSON viewer. | <img src="https://jless.io/assets/jless-recording.gif" /> |
| [jq]          | Lightweight and flexible command-line JSON processor. | <img src="https://stedolan.github.io/jq/jq.png" width="40%" /> |
| [just]        | Handy way to save and run project-specific commands. | <img src="https://raw.githubusercontent.com/casey/just/master/screenshot.png" /> |
| [lf]          | File manager with a heavy inspiration from ranger. | <img src="http://i.imgur.com/p95xzUj.png" /> |
| [lsd]         | Rewrite of GNU `ls` with lots of added features like colors, icons, tree-view, more formatting options etc. | <img src="https://raw.githubusercontent.com/Peltoche/lsd/assets/screen_lsd.png" /> |
| [mkcert]      | A simple zero-config tool to make locally trusted development certificates with any names you'd like. | <img src="https://user-images.githubusercontent.com/1225294/51066373-96d4aa80-15be-11e9-91e2-f4e44a3a4458.png" /> |
| [ncdu]        | Ncdu is a disk usage analyzer with an ncurses interface. | <img src="https://dev.yorhel.nl/img/ncdudone-2.png" /> |
| [ripgrep]     | ripgrep is a line-oriented search tool that recursively searches the current directory for a regex pattern. | <img src="https://burntsushi.net/stuff/ripgrep1.png" /> |
| [sheldon]     | A fast, configurable, shell plugin manager. | <img src="https://user-images.githubusercontent.com/17109887/60550665-02573380-9d29-11e9-84e9-5dfa89b11895.png" /> |
| [starship]    | Minimal, blazing-fast, and infinitely customizable prompt for any shell. | <img src="https://raw.githubusercontent.com/starship/starship/master/media/demo.gif" /> |
| [stern]       | Stern allows you to `tail` multiple pods on Kubernetes and multiple containers within the pod. Each result is color coded for quicker debugging. | <img src="https://i0.wp.com/blog.knoldus.com/wp-content/uploads/2021/01/image.png?ssl=1" /> |
| [xh]          | Friendly and fast tool for sending HTTP requests. It reimplements as much as possible of HTTPie's excellent design. | [![asciicast](https://raw.githubusercontent.com/ducaale/xh/master/assets/xh-demo.gif)](https://asciinema.org/a/475190) |
| [yj]          | Convert between YAML, TOML, JSON, and HCL. Preserves map order. | <img src="https://raw.githubusercontent.com/sclevine/yj/main/logo.png" width="30%" /> |
| [yq]          | Portable command-line YAML, JSON, XML, CSV, TOML and properties processor. | <img src="https://miro.medium.com/v2/resize:fit:640/1*gsqh7A_ivvZM5ht66hx3Xw.png" /> |
| [zoxide]      | zoxide is a **smarter cd command**, inspired by z and autojump. | <img src="https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/contrib/tutorial.webp" /> |

## License

See each program's license.

[bandwhich]: https://github.com/imsnif/bandwhich
[bat]: https://github.com/sharkdp/bat
[bottom]: https://github.com/ClementTsang/bottom
[btop]: https://github.com/aristocratos/btop
[chafa]: https://hpjansson.org/chafa
[crane]: https://github.com/google/go-containerregistry
[dua]: https://github.com/Byron/dua-cli
[duf]: https://github.com/muesli/duf
[dust]: https://github.com/bootandy/dust
[dyff]: https://github.com/homeport/dyff
[erdtree]: https://github.com/solidiquis/erdtree
[fd]: https://github.com/sharkdp/fd
[fzf]: https://github.com/junegunn/fzf
[glow]: https://github.com/charmbracelet/glow
[hexyl]: https://github.com/sharkdp/hexyl
[hyperfine]: https://github.com/sharkdp/hyperfine
[jless]: https://github.com/PaulJuliusMartinez/jless
[jq]: https://github.com/stedolan/jq
[just]: https://github.com/casey/just
[lf]: https://github.com/gokcehan/lf
[lsd]: https://github.com/lsd-rs/lsd
[mkcert]: https://github.com/FiloSottile/mkcert
[ncdu]: https://dev.yorhel.nl/ncdu
[neovim]: https://github.com/neovim/neovim
[ripgrep]: https://github.com/BurntSushi/ripgrep
[sheldon]: https://github.com/rossmacarthur/sheldon
[starship]: https://github.com/starship/starship
[stern]: https://github.com/stern/stern
[tmux]: https://github.com/tmux/tmux
[xh]: https://github.com/ducaale/xh
[yj]: https://github.com/sclevine/yj
[yq]: https://github.com/mikefarah/yq
[zoxide]: https://github.com/ajeetdsouza/zoxide
