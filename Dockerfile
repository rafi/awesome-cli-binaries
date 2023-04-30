# syntax = docker/dockerfile:1.2
FROM debian:stable-slim AS builder

# Prepare environment
RUN apt-get update \
    && apt-get upgrade --yes --show-upgraded \
    && apt-get install --yes locales \
    && apt-get install --yes bash curl file wget unzip \
        automake build-essential pkg-config libssl-dev \
    && rm -rf /var/lib/apt/lists/*

COPY ./.files/.config/terminfo /etc/terminfo
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV build_path /opt/tmux
ENV PATH $build_path/bin:$PATH
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
WORKDIR /tmp
CMD ["bash"]

# tmux ncurses libevent
ENV libevent_version 2.1.12
ENV ncurses_version 6.4
ENV tmux_version 3.3a

# libevent
ENV libevent_name libevent-${libevent_version}-stable
ENV libevent_url https://github.com/libevent/libevent/releases/download/release-${libevent_version}-stable/${libevent_name}.tar.gz
RUN curl --retry 5 -LO "$libevent_url" && \
    tar xvzf $libevent_name.tar.gz && \
    cd $libevent_name && \
    ./configure --prefix=$build_path && \
    make && \
    make install && \
    cd .. && \
    rm -fr $libevent_name.tar.gz $libevent_name

# ncurses
ENV ncurses_name ncurses-${ncurses_version}
ENV ncurses_url https://ftp.gnu.org/pub/gnu/ncurses/${ncurses_name}.tar.gz
RUN curl --retry 5 -LO "$ncurses_url" && \
    tar xvzof ${ncurses_name}.tar.gz && \
    cd $ncurses_name && \
    ./configure --prefix=$build_path \
    --with-default-terminfo-dir=/usr/share/terminfo \
    --with-terminfo-dirs="/etc/terminfo:/lib/terminfo:/usr/share/terminfo" \
    --enable-pc-files \
    --with-pkg-config-libdir=$build_path/lib/pkgconfig && \
    make && \
    make install && \
    cd .. && \
    rm -fr ${ncurses_name}.tar.gz $ncurses_name

# tmux
ENV tmux_name tmux-${tmux_version}
ENV tmux_url https://github.com/tmux/tmux/releases/download/$tmux_version/$tmux_name.tar.gz
RUN curl --retry 5 -LO "$tmux_url" && \
    tar xvzof $tmux_name.tar.gz && \
    cd $tmux_name && \
    PKG_CONFIG_PATH=$build_path/lib/pkgconfig ./configure --enable-static --prefix=$build_path && \
    make && \
    make install && \
    cd .. && \
    rm -fr $tmux_name.tar.gz $tmux_name

RUN tmux -V

# --------------------------------------------------------------------------

FROM alpine:3.17 AS downloader

LABEL io.rafi.source="https://github.com/rafi/awesome-cli-binaries"
LABEL io.rafi.revision="50"

RUN apk add --no-cache ca-certificates=20220614-r4 curl=8.0.1-r0 bash=5.2.15-r0

ENV dl_path /usr/local/bin
ENV opts="-i . -m musl"
WORKDIR $dl_path
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY --from=builder /opt/tmux/bin/tmux .

RUN ubi_name=ubi-Linux-x86_64-musl \
    && ubi_version="$(curl https://api.github.com/repos/houseabsolute/ubi/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')" \
    && ubi_url="https://github.com/houseabsolute/ubi/releases/download/$ubi_version/$ubi_name.tar.gz" \
    && curl --retry 5 -L "$ubi_url" | tar -xzoC "$dl_path" ubi \
    && chmod 770 "$dl_path"/ubi \
    && ubi --version

RUN --mount=type=secret,id=token GITHUB_TOKEN="$(cat /run/secrets/token)" \
    && export GITHUB_TOKEN \
    && ubi -p imsnif/bandwhich $opts && bandwhich --version \
    && ubi -p sharkdp/bat $opts && bat --version \
    && ubi -p ClementTsang/bottom --exe btm $opts && btm --version \
    && ubi -u https://hpjansson.org/chafa/releases/static/chafa-1.12.4-1-x86_64-linux-gnu.tar.gz --exe chafa -i . \
    && ubi -p google/go-containerregistry --exe crane $opts && crane version \
    && ubi -p Byron/dua-cli --exe dua $opts && dua --version \
    && ubi -p muesli/duf $opts && duf -version \
    && ubi -p bootandy/dust $opts && dust --version \
    && ubi -p homeport/dyff $opts && dyff version \
    && ubi -p sharkdp/fd $opts && fd --version \
    && ubi -p junegunn/fzf $opts && fzf --version \
    && ubi -p charmbracelet/glow $opts && glow --version \
    && ubi -p sharkdp/hexyl $opts && hexyl --version \
    && ubi -p sharkdp/hyperfine $opts && hyperfine --version \
    && ubi -p PaulJuliusMartinez/jless -i . \
    && ubi -p stedolan/jq $opts && jq --version \
    && ubi -p gokcehan/lf -i . && lf --version \
    && ubi -p FiloSottile/mkcert $opts && mkcert --version \
    && ubi -u https://dev.yorhel.nl/download/ncdu-linux-x86_64-1.15.1.tar.gz --exe ncdu -i . && ncdu --version \
    && ubi -p genuinetools/reg -i . && reg version \
    && ubi -p BurntSushi/ripgrep --exe rg $opts && rg --version \
    && ubi -p starship/starship $opts && starship -V \
    && ubi -p stern/stern $opts && stern --version \
    && ubi -p ducaale/xh $opts && xh --version \
    && ubi -p sclevine/yj $opts && yj -v \
    && ubi -p mikefarah/yq -i . -m amd64 && yq --version \
    && ubi -p ajeetdsouza/zoxide $opts && zoxide --version

# Neovim appimage
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.9.0/nvim.appimage \
    && chmod ug+x nvim.appimage

# --------------------------------------------------------------------------
