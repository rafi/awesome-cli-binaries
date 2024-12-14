# syntax = docker/dockerfile:1
FROM debian:stable-slim AS tmux-builder

# Prepare environment
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade --yes --show-upgraded \
    && apt-get install --yes \
        locales automake build-essential pkg-config libssl-dev libtool \
        libutf8proc-dev bison byacc imagemagick ca-certificates curl file \
    && apt-get purge --yes manpages manpages-dev \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

ENV BUILD_DIR=/opt/tmux
ENV PATH=$BUILD_DIR/bin:$PATH
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
CMD ["bash"]
WORKDIR /tmp

# Setup locales and terminfo
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
COPY ./.files/.config/terminfo /etc/terminfo

# libevent
ENV libevent_version=2.1.12
ENV libevent_name=libevent-${libevent_version}-stable
ENV libevent_url=https://github.com/libevent/libevent/releases/download/release-${libevent_version}-stable/${libevent_name}.tar.gz
RUN curl --retry 5 -LO "$libevent_url" && \
    tar xvzf "$libevent_name.tar.gz" && \
    cd "$libevent_name" && \
    autoupdate && \
    sh autogen.sh && \
    ./configure --prefix="$BUILD_DIR" --enable-shared && \
    make -j4 && \
    make install && \
    cd .. && \
    rm -fr "$libevent_name.tar.gz" "$libevent_name"

# ncurses
ENV ncurses_version=6.5
ENV ncurses_name=ncurses-${ncurses_version}
ENV ncurses_url=https://ftp.gnu.org/pub/gnu/ncurses/${ncurses_name}.tar.gz
RUN curl --retry 5 -LO "$ncurses_url" && \
    tar xvzof "${ncurses_name}.tar.gz" && \
    cd "$ncurses_name" && \
    ./configure --prefix="$BUILD_DIR" \
        --enable-pc-files \
        --with-shared \
        --with-termlib \
        --with-default-terminfo-dir=/usr/share/terminfo \
        --with-terminfo-dirs="/etc/terminfo:/lib/terminfo:/usr/share/terminfo" \
        --with-pkg-config-libdir="$BUILD_DIR/lib/pkgconfig" && \
    make -j4 && \
    make install && \
    cd .. && \
    rm -fr "${ncurses_name}.tar.gz" "$ncurses_name"

# tmux
ENV tmux_version=3.5a
ENV tmux_name=tmux-${tmux_version}
ENV tmux_url=https://github.com/tmux/tmux/releases/download/$tmux_version/$tmux_name.tar.gz
RUN curl --retry 5 -LO "$tmux_url" && \
    tar xvzof "$tmux_name.tar.gz" && \
    cd "$tmux_name" && \
    export LDFLAGS="-L$BUILD_DIR/lib" && \
    export CPPFLAGS="-I$BUILD_DIR/include -I$BUILD_DIR/include/ncurses -I$BUILD_DIR/include/event2" && \
    export PKG_CONFIG_PATH="$BUILD_DIR/lib/pkgconfig" && \
    ./configure --enable-utf8proc --prefix="$BUILD_DIR" --enable-static && \
    make -j4 && \
    make install && \
    cd .. && \
    rm -fr "$tmux_name.tar.gz" "$tmux_name"

RUN "$BUILD_DIR/bin/tmux" -V

# --------------------------------------------------------------------------

# Build fish-shell from source from faho fork with `fish-installer` branch:
# https://github.com/faho/fish-shell/tree/fish-installer
# Use Debian 10.x "buster" for older glib versions.
FROM rust:slim-buster AS fish-builder

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install --no-install-recommends --yes git \
    && rm -rf /var/lib/apt/lists/* /var/cache/* /var/log/* /var/lib/*

WORKDIR /root

ARG BUILD_REVISION=126
LABEL io.rafi.revision="$BUILD_REVISION"

RUN git clone https://github.com/fish-shell/fish-shell.git && \
    cd fish-shell && \
    FISH_BUILD_DOCS=0 cargo build --release && \
    rm -rf /usr/local/cargo/registry /usr/local/cargo/git

# --------------------------------------------------------------------------

FROM debian:stable-slim AS downloader

ARG BUILD_REVISION=126
LABEL io.rafi.source="https://github.com/rafi/awesome-cli-binaries"
LABEL io.rafi.revision="$BUILD_REVISION"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade --yes --show-upgraded \
    && apt-get install --yes bash wget \
    && apt-get purge --yes manpages manpages-dev \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/* /var/cache/* /var/log/*

WORKDIR /usr/local/bin

# Pre-defined build arguments
# See https://docs.docker.com/build/building/variables/#pre-defined-build-arguments
ARG TARGETARCH

# dra (Download Release Assets from GitHub)
RUN arch="$(uname -m)" \
    && dra_name="${arch}-unknown-linux-$([ "$arch" = x86_64 ] && echo musl || echo gnu)" \
    && dra_version="$(wget -qO- --no-hsts https://api.github.com/repos/devmatteini/dra/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')" \
    && dra_url="https://github.com/devmatteini/dra/releases/download/$dra_version/dra-$dra_version-$dra_name.tar.gz" \
    && wget -qO- --no-hsts "$dra_url" | tar -xzo --strip-components 1 "dra-$dra_version-$dra_name/dra" \
    && chmod 770 dra \
    && dra --version

RUN --mount=type=secret,id=token \
    GITHUB_TOKEN="$(cat /run/secrets/token)" && export GITHUB_TOKEN \
    && dra download -ai upx/upx && upx --version \
    && dra download -ai imsnif/bandwhich && bandwhich --version \
    && dra download -ai sharkdp/bat && bat --version \
    && dra download -ai aristocratos/btop && btop --version \
    && dra download -aI crane google/go-containerregistry && upx crane && crane version \
    && dra download -ai dandavison/delta && delta --version \
    && dra download -s diff-so-fancy so-fancy/diff-so-fancy && chmod ug+x diff-so-fancy \
    && dra download -ai Byron/dua-cli && dua --version \
    && dra download -ai muesli/duf && duf -version \
    && dra download -ai bootandy/dust && dust --version \
    && dra download -ai homeport/dyff && dyff version

RUN --mount=type=secret,id=token \
    GITHUB_TOKEN="$(cat /run/secrets/token)" && export GITHUB_TOKEN \
    && dra download -ai solidiquis/erdtree && erd --version \
    && dra download -ai eza-community/eza && eza --version \
    && dra download -ai sharkdp/fd && fd --version \
    && dra download -aio fx antonmedv/fx && upx fx && fx --version \
    && dra download -ai junegunn/fzf && fzf --version && (fzf --bash > fzf.bash && fzf --zsh > fzf.zsh && fzf --fish > fzf.fish) \
    && dra download -ai charmbracelet/glow && upx glow && glow --version && rm -rf ~/.cache ~/.config \
    && dra download -ai mrjackwills/havn && havn --version \
    && dra download -ai sharkdp/hexyl && hexyl --version \
    && dra download -ai sharkdp/hyperfine && hyperfine --version \
    && dra download -aio jq stedolan/jq && jq --version \
    && dra download -ai casey/just && just --version

RUN --mount=type=secret,id=token \
    GITHUB_TOKEN="$(cat /run/secrets/token)" && export GITHUB_TOKEN \
    && dra download -ai lsd-rs/lsd && lsd --version \
    && dra download -aio mkcert FiloSottile/mkcert && mkcert --version \
    && dra download -ai MilesCranmer/rip2 && rip --version \
    && dra download -ai BurntSushi/ripgrep && rg --version \
    && dra download -ai starship/starship && starship -V && rm -rf ~/.cache \
    && dra download -ai stern/stern && upx stern && stern --version \
    && dra download -ai ducaale/xh && xh --version \
    && dra download -ai sxyazi/yazi && yazi --version && rm -rf ~/.local /tmp/yazi* \
    && dra download -aI yq_linux_${TARGETARCH} -o yq mikefarah/yq && yq --version \
    && dra download -ai ajeetdsouza/zoxide && zoxide --version

# Chafa
ARG chafa_version=1.14.5
RUN wget -qO- --no-hsts \
    https://hpjansson.org/chafa/releases/static/chafa-${chafa_version}-1-x86_64-linux-gnu.tar.gz | tar -xzo --strip-components 1

# Neovim repositories
# - github.com/neovim/neovim - official releases
# - github.com/neovim/neovim-releases - best-effort builds with glibc 2.17
RUN wget -q --no-hsts \
    https://github.com/neovim/neovim-releases/releases/download/stable/nvim-linux64.tar.gz

# Copy compiled tmux
COPY --from=tmux-builder /opt/tmux/bin/tmux .

# Copy compiled fish-shell
COPY --from=fish-builder /root/fish-shell/target/release/fish .
COPY --from=fish-builder /root/fish-shell/target/release/fish_indent .
COPY --from=fish-builder /root/fish-shell/target/release/fish_key_reader .

# Pre-made dotfiles
COPY .files/.config /root/.config

# --------------------------------------------------------------------------
