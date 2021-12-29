FROM debian:stable-slim AS builder

# Prepare environment
RUN apt-get update \
    && apt-get upgrade --yes --show-upgraded \
    && apt-get install --yes locales \
    && apt-get install --yes bash curl file wget \
        automake build-essential pkg-config libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

COPY ./.files/.config/terminfo /etc/terminfo

ENV root /opt

WORKDIR /tmp

CMD ["bash"]

# tmux ncurses libevent
ENV libevent_version 2.1.12
ENV ncurses_version 6.2
ENV tmux_version 3.2a

# libevent
ENV libevent_name libevent-${libevent_version}-stable
ENV libevent_url https://github.com/libevent/libevent/releases/download/release-${libevent_version}-stable/${libevent_name}.tar.gz
RUN curl --retry 5 -LO "$libevent_url" && \
    tar xvzf $libevent_name.tar.gz && \
    cd $libevent_name && \
    ./configure --prefix=$root && \
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
    ./configure --prefix=$root \
        --with-default-terminfo-dir=/usr/share/terminfo \
        --with-terminfo-dirs="/etc/terminfo:/lib/terminfo:/usr/share/terminfo" \
        --enable-pc-files \
        --with-pkg-config-libdir=$root/lib/pkgconfig && \
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
    PKG_CONFIG_PATH=$root/lib/pkgconfig ./configure --enable-static --prefix=$root && \
    make && \
    make install && \
    cd .. && \
    rm -fr $tmux_name.tar.gz $tmux_name
RUN $root/bin/tmux -V

# app versions
ENV bandwhich_version 0.20.0
ENV bat_version 0.18.3
ENV bottom_version 0.6.3
ENV chafa_version 1.6.1
ENV crane_version 0.7.0
ENV dua_version 2.10.9
ENV duf_version 0.5.0
ENV dust_version 0.7.5
ENV dyff_version 1.1.3
ENV fd_version 8.3.0
ENV fzf_version 0.29.0
ENV glow_version 1.4.1
ENV heksa_version 1.14.0
ENV hexyl_version 0.9.0
ENV hyperfine_version 1.11.0
ENV jq_version 1.6
ENV lf_version r26
ENV mkcert_version 1.4.3
ENV ncdu_version 1.15.1
ENV reg_version 0.16.1
ENV ripgrep_version 13.0.0
ENV starship_version 1.1.1
ENV stern_version 1.21.0
ENV yank_version 1.2.0
ENV xh_version 0.13.0
ENV yj_version 5.0.0
ENV zoxide_version 0.8.0

# bandwhich
ENV bandwhich_name bandwhich-v${bandwhich_version}-x86_64-unknown-linux-musl
ENV bandwhich_url https://github.com/imsnif/bandwhich/releases/download/$bandwhich_version/$bandwhich_name.tar.gz
RUN curl --retry 5 -L "$bandwhich_url" \
        | tar -xzoC $root/bin/ bandwhich \
    && chmod 770 $root/bin/bandwhich
RUN $root/bin/bandwhich --version

# bat
ENV bat_name bat-v${bat_version}-x86_64-unknown-linux-musl
ENV bat_url https://github.com/sharkdp/bat/releases/download/v$bat_version/$bat_name.tar.gz
RUN curl --retry 5 -L "$bat_url" \
        | tar -xzoC $root/bin/ --wildcards --strip-components 1 '*/bat' \
    && chmod 770 $root/bin/bat
RUN $root/bin/bat --version

# bottom
ENV bottom_name bottom_x86_64-unknown-linux-musl
ENV bottom_url https://github.com/ClementTsang/bottom/releases/download/${bottom_version}/${bottom_name}.tar.gz
RUN curl --retry 5 -L "$bottom_url" \
        | tar -xzoC $root/bin/ btm \
    && chmod 770 $root/bin/btm
RUN $root/bin/btm --version

# chafa
ENV chafa_name chafa-${chafa_version}-1-x86_64-linux-gnu
ENV chafa_url https://hpjansson.org/chafa/releases/static/${chafa_name}.tar.gz
RUN curl --retry 5 -L "$chafa_url" \
        | tar -xzoC $root/bin/ --wildcards --strip-components 1 '*/chafa' \
    && chmod 770 $root/bin/chafa
RUN $root/bin/chafa --version

# crane
ENV crane_name go-containerregistry_Linux_x86_64
ENV crane_url https://github.com/google/go-containerregistry/releases/download/v${crane_version}/${crane_name}.tar.gz
RUN curl --retry 5 -L "$crane_url" \
        | tar -xzoC $root/bin/ 'crane' \
    && chmod 770 $root/bin/crane
RUN $root/bin/crane version

# dua-cli
ENV dua_name dua-v${dua_version}-x86_64-unknown-linux-musl
ENV dua_url https://github.com/Byron/dua-cli/releases/download/v${dua_version}/${dua_name}.tar.gz
RUN curl --retry 5 -L "$dua_url" \
        | tar -xzoC $root/bin/ --wildcards --strip-components 1 '*/dua' \
    && chmod 770 $root/bin/dua
RUN $root/bin/dua --version

# duf
ENV duf_name duf_${duf_version}_linux_x86_64
ENV duf_url https://github.com/muesli/duf/releases/download/v${duf_version}/${duf_name}.tar.gz
RUN curl --retry 5 -L "$duf_url" \
        | tar -xzoC $root/bin/ duf \
    && chmod 770 $root/bin/duf
RUN $root/bin/duf -version

# dust
ENV dust_name dust-v${dust_version}-x86_64-unknown-linux-musl
ENV dust_url https://github.com/bootandy/dust/releases/download/v${dust_version}/${dust_name}.tar.gz
RUN curl --retry 5 -L "$dust_url" \
        | tar -xzoC $root/bin/ --wildcards --strip-components 1 '*/dust' \
    && chmod 770 $root/bin/dust
RUN $root/bin/dust --version

# dyff
ENV dyff_name dyff-linux-amd64
ENV dyff_url https://github.com/homeport/dyff/releases/download/v$dyff_version/$dyff_name
RUN curl --retry 5 -Lo $root/bin/dyff "$dyff_url" \
    && chmod 770 $root/bin/dyff
RUN $root/bin/dyff version

# fd
ENV fd_name fd-v${fd_version}-x86_64-unknown-linux-musl
ENV fd_url https://github.com/sharkdp/fd/releases/download/v$fd_version/$fd_name.tar.gz
RUN curl --retry 5 -L "$fd_url" \
        | tar -xzoC $root/bin/ --wildcards --strip-components 1 '*/fd' \
    && chmod 770 $root/bin/fd
RUN $root/bin/fd --version

# fzf
ENV fzf_name fzf-${fzf_version}-linux_amd64
ENV fzf_url https://github.com/junegunn/fzf/releases/download/$fzf_version/$fzf_name.tar.gz
RUN curl --retry 5 -L "$fzf_url" \
        | tar -xzoC $root/bin/ fzf \
    && chmod 770 $root/bin/fzf
RUN $root/bin/fzf --version

# glow
ENV glow_name glow_${glow_version}_linux_x86_64
ENV glow_url https://github.com/charmbracelet/glow/releases/download/v$glow_version/$glow_name.tar.gz
RUN curl --retry 5 -L "$glow_url" \
        | tar -xzoC $root/bin/ glow \
    && chmod 770 $root/bin/glow
RUN $root/bin/glow --version

# heksa
ENV heksa_name heksa-v${heksa_version}-linux-amd64
ENV heksa_url https://github.com/raspi/heksa/releases/download/v$heksa_version/$heksa_name.tar.gz
RUN curl --retry 5 -L "$heksa_url" \
        | tar -xzoC $root/bin/ --wildcards --strip-components 3 '*/*/*/heksa' \
    && chmod 770 $root/bin/heksa
RUN $root/bin/heksa --version

# hexyl
ENV hexyl_name hexyl-v${hexyl_version}-x86_64-unknown-linux-gnu
ENV hexyl_url https://github.com/sharkdp/hexyl/releases/download/v$hexyl_version/$hexyl_name.tar.gz
RUN curl --retry 5 -L "$hexyl_url" \
        | tar -xzoC $root/bin/ --wildcards --strip-components 1 '*/hexyl' \
    && chmod 770 $root/bin/hexyl
RUN $root/bin/hexyl --version

# hyperfine
ENV hyperfine_name hyperfine-v${hyperfine_version}-x86_64-unknown-linux-musl
ENV hyperfine_url https://github.com/sharkdp/hyperfine/releases/download/v$hyperfine_version/$hyperfine_name.tar.gz
RUN curl --retry 5 -L "$hyperfine_url" \
        | tar -xzoC $root/bin/ --wildcards --strip-components 1 '*/hyperfine' \
    && chmod 770 $root/bin/hyperfine
RUN $root/bin/hyperfine --version

# jq
ENV jq_name jq-linux64
ENV jq_url https://github.com/stedolan/jq/releases/download/jq-$jq_version/$jq_name
RUN curl --retry 5 -Lo $root/bin/jq "$jq_url" && \
    chmod 770 $root/bin/jq
RUN $root/bin/jq --version

# lf
ENV lf_name lf-linux-amd64
ENV lf_url https://github.com/gokcehan/lf/releases/download/$lf_version/$lf_name.tar.gz
RUN curl --retry 5 -L "$lf_url" \
        | tar -xzoC $root/bin/ lf \
    && chmod 770 $root/bin/lf
RUN USER=root $root/bin/lf --version

# mkcert
ENV mkcert_name mkcert-v${mkcert_version}-linux-amd64
ENV mkcert_url https://github.com/FiloSottile/mkcert/releases/download/v$mkcert_version/$mkcert_name
RUN curl --retry 5 -Lo $root/bin/mkcert "$mkcert_url" \
    && chmod 770 $root/bin/mkcert
RUN $root/bin/mkcert --version

# ncdu
ENV ncdu_name ncdu-linux-x86_64-${ncdu_version}
ENV ncdu_url https://dev.yorhel.nl/download/$ncdu_name.tar.gz
RUN curl --retry 5 -L "$ncdu_url" \
        | tar -xzoC $root/bin/ ncdu \
    && chmod 770 $root/bin/ncdu
RUN $root/bin/ncdu --version

# reg
ENV reg_name reg-linux-amd64
ENV reg_url https://github.com/genuinetools/reg/releases/download/v$reg_version/$reg_name
RUN curl --retry 5 -Lo $root/bin/reg "$reg_url" \
    && chmod 770 $root/bin/reg
RUN $root/bin/reg version

# ripgrep
ENV ripgrep_name ripgrep-${ripgrep_version}-x86_64-unknown-linux-musl
ENV ripgrep_url https://github.com/BurntSushi/ripgrep/releases/download/$ripgrep_version/$ripgrep_name.tar.gz
RUN curl --retry 5 -L "$ripgrep_url" \
        | tar -xzoC $root/bin/ --wildcards --strip-components 1 '*/rg' \
    && chmod 770 $root/bin/rg
RUN $root/bin/rg --version

# starship
ENV starship_name starship-x86_64-unknown-linux-musl
ENV starship_url https://github.com/starship/starship/releases/download/v$starship_version/$starship_name.tar.gz
RUN curl --retry 5 -L "$starship_url" \
        | tar -xzoC $root/bin/ starship \
    && chmod 770 $root/bin/starship
RUN $root/bin/starship -V

# stern
ENV stern_name stern_${stern_version}_linux_amd64
ENV stern_url https://github.com/stern/stern/releases/download/v$stern_version/$stern_name.tar.gz
RUN curl --retry 5 -L "$stern_url" \
        | tar -xzoC $root/bin/ 'stern' \
    && chmod 770 $root/bin/stern
RUN $root/bin/stern --version

# yank
ENV yank_name yank-${yank_version}
ENV yank_url https://github.com/mptre/yank/releases/download/v${yank_version}/${yank_name}.tar.gz
RUN curl --retry 5 -L "$yank_url" \
        | tar -xzo \
    && cd $yank_name \
    && make \
    && chmod 770 yank \
    && mv yank $root/bin/ \
    && cd .. \
    && rm -rf $yank_name
RUN $root/bin/yank -v

# xh
ENV xh_name xh-v${xh_version}-x86_64-unknown-linux-musl
ENV xh_url https://github.com/ducaale/xh/releases/download/v$xh_version/${xh_name}.tar.gz
RUN curl --retry 5 -L "$xh_url" \
        | tar -xzoC $root/bin/ --wildcards --strip-components 1 '*/xh' \
    && chmod 770 $root/bin/xh
RUN $root/bin/xh --version

# yj
ENV yj_name yj-linux
ENV yj_url https://github.com/sclevine/yj/releases/download/v$yj_version/$yj_name
RUN curl --retry 5 -Lo $root/bin/yj "$yj_url" \
    && chmod 770 $root/bin/yj
RUN $root/bin/yj -v

# zoxide
ENV zoxide_name zoxide-v${zoxide_version}-x86_64-unknown-linux-musl
ENV zoxide_url https://github.com/ajeetdsouza/zoxide/releases/download/v$zoxide_version/$zoxide_name.tar.gz
RUN curl --retry 5 -L "$zoxide_url" \
        | tar -xzoC $root/bin/ zoxide \
    && chmod 770 $root/bin/zoxide
RUN $root/bin/zoxide --version

FROM debian:stable-slim

LABEL io.rafi.source="https://github.com/rafi/awesome-cli-binaries"
LABEL io.rafi.revision="41"

ENV root /opt

COPY --from=builder $root/bin $root/bin

#  vim: set ts=2 sw=4 tw=80 et :
