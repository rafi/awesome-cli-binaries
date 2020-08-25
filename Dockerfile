FROM debian:stable-slim AS builder

# Locales
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apt-get update && \
    apt-get upgrade --yes --show-upgraded

RUN apt-get install --yes \
        bash curl file wget \
        automake build-essential locales pkg-config libssl-dev

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ADD ./.files/.config/terminfo /etc/terminfo
ENV root /opt

WORKDIR /tmp

CMD ["bash"]

# tmux ncurses libevent
ENV libevent_version 2.1.12
ENV ncurses_version 6.2
ENV tmux_version 3.1b

# others
ENV bat_version 0.15.4
ENV chafa_version 1.4.1
ENV dyff_version 1.0.3
ENV fd_version 8.1.1
ENV fzf_version 0.22.0
ENV glow_version 0.2.0
ENV heksa_version 1.13.0
ENV hexyl_version 0.8.0
ENV httpiego_version 0.6.0
ENV jq_version 1.6
ENV lf_version r16
ENV mkcert_version 1.4.1
ENV ncdu_version 1.15.1
ENV reg_version 0.16.1
ENV ripgrep_version 12.1.1
ENV starship_version 0.44.0
ENV stern_version 1.11.0
ENV yank_version 1.2.0
ENV yj_version 5.0.0
ENV zoxide_version 0.4.3

# libevent
ENV libevent_name libevent-${libevent_version}-stable
ENV libevent_url https://github.com/libevent/libevent/releases/download/release-${libevent_version}-stable/${libevent_name}.tar.gz
RUN curl -LO "$libevent_url" && \
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
RUN curl -LO "$ncurses_url" && \
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
RUN curl -LO "$tmux_url" && \
    tar xvzof $tmux_name.tar.gz && \
    cd $tmux_name && \
    PKG_CONFIG_PATH=$root/lib/pkgconfig ./configure --enable-static --prefix=$root && \
    make && \
    make install && \
    cd .. && \
    rm -fr $tmux_name.tar.gz $tmux_name
RUN $root/bin/tmux -V

# bat
ENV bat_name bat-v${bat_version}-x86_64-unknown-linux-musl
ENV bat_url https://github.com/sharkdp/bat/releases/download/v$bat_version/$bat_name.tar.gz
RUN curl -LO "$bat_url" && \
    tar xvzof $bat_name.tar.gz && \
    mv $bat_name/bat $root/bin/ && \
    rm -fr $bat_name.tar.gz $bat_name
RUN $root/bin/bat --version

# chafa
ENV chafa_name chafa-${chafa_version}-1-x86_64-linux-gnu
ENV chafa_url https://hpjansson.org/chafa/releases/static/${chafa_name}.tar.gz
RUN curl -LO "$chafa_url" && \
    tar -xvzo --strip-components=1 -f $chafa_name.tar.gz && \
    chmod 775 chafa && \
    mv chafa $root/bin/ && \
    rm -fr $chafa_name.tar.gz
RUN $root/bin/chafa --version

# dyff
ENV dyff_name dyff-linux-amd64
ENV dyff_url https://github.com/homeport/dyff/releases/download/v$dyff_version/$dyff_name
RUN curl -LO "$dyff_url" && \
    chmod 775 $dyff_name && \
    mv $dyff_name $root/bin/dyff
RUN $root/bin/dyff version

# fd
ENV fd_name fd-v${fd_version}-x86_64-unknown-linux-musl
ENV fd_url https://github.com/sharkdp/fd/releases/download/v$fd_version/$fd_name.tar.gz
RUN curl -LO "$fd_url" && \
    tar xvzof $fd_name.tar.gz && \
    mv $fd_name/fd $root/bin/ && \
    rm -fr $fd_name.tar.gz $fd_name
RUN $root/bin/fd --version

# fzf
ENV fzf_name fzf-${fzf_version}-linux_amd64
ENV fzf_url https://github.com/junegunn/fzf-bin/releases/download/$fzf_version/$fzf_name.tgz
RUN curl -LO "$fzf_url" && \
    tar xvzof $fzf_name.tgz && \
    mv fzf $root/bin/ && \
    rm -fr $fzf_name.tgz
RUN $root/bin/fzf --version

# glow
ENV glow_name glow_${glow_version}_linux_x86_64
ENV glow_url https://github.com/charmbracelet/glow/releases/download/v$glow_version/$glow_name.tar.gz
RUN curl -LO "$glow_url" && \
    tar xvzof $glow_name.tar.gz glow && \
    mv glow $root/bin/ && \
    rm -fr $glow_name.tar.gz
RUN $root/bin/glow --version

# heksa
ENV heksa_name heksa-v${heksa_version}-linux-amd64
ENV heksa_url https://github.com/raspi/heksa/releases/download/v$heksa_version/$heksa_name.tar.gz
RUN curl -LO "$heksa_url" && \
    tar xvzo --strip-components=3 -f $heksa_name.tar.gz && \
    mv heksa $root/bin/ && \
    rm -fr $heksa_name.tar.gz
RUN $root/bin/heksa --version

# hexyl
ENV hexyl_name hexyl-v${hexyl_version}-x86_64-unknown-linux-gnu
ENV hexyl_url https://github.com/sharkdp/hexyl/releases/download/v$hexyl_version/$hexyl_name.tar.gz
RUN curl -LO "$hexyl_url" && \
    tar xvzo -f $hexyl_name.tar.gz && \
    mv $hexyl_name/hexyl $root/bin/ && \
    rm -fr $hexyl_name.tar.gz $hexyl_name
RUN $root/bin/hexyl --version

# httpie-go
ENV httpiego_name httpie-go_linux_amd64
ENV httpiego_url https://github.com/nojima/httpie-go/releases/download/v$httpiego_version/$httpiego_name
RUN curl -LO "$httpiego_url" && \
    chmod 775 $httpiego_name && \
    mv $httpiego_name $root/bin/ht
RUN $root/bin/ht --version

# jq
ENV jq_name jq-linux64
ENV jq_url https://github.com/stedolan/jq/releases/download/jq-$jq_version/$jq_name
RUN curl -LO "$jq_url" && \
    chmod 775 $jq_name && \
    mv $jq_name $root/bin/jq
RUN $root/bin/jq --version

# lf
ENV lf_name lf-linux-amd64
ENV lf_url https://github.com/gokcehan/lf/releases/download/$lf_version/$lf_name.tar.gz
RUN curl -LO "$lf_url" && \
    tar xvzof $lf_name.tar.gz && \
    mv lf $root/bin/ && \
    rm -fr $lf_name.tar.gz
RUN USER=root $root/bin/lf --version

# mkcert
ENV mkcert_name mkcert-v${mkcert_version}-linux-amd64
ENV mkcert_url https://github.com/FiloSottile/mkcert/releases/download/v$mkcert_version/$mkcert_name
RUN curl -LO "$mkcert_url" && \
    chmod 775 $mkcert_name && \
    mv $mkcert_name $root/bin/mkcert
RUN $root/bin/mkcert --version

# ncdu
ENV ncdu_name ncdu-linux-x86_64-${ncdu_version}
ENV ncdu_url https://dev.yorhel.nl/download/$ncdu_name.tar.gz
RUN curl -LO "$ncdu_url" && \
    tar xvzof $ncdu_name.tar.gz && \
    mv ncdu $root/bin/ && \
    rm -fr $ncdu_name.tar.gz
RUN $root/bin/ncdu --version

# reg
ENV reg_name reg-linux-amd64
ENV reg_url https://github.com/genuinetools/reg/releases/download/v$reg_version/$reg_name
RUN curl -LO "$reg_url" && \
    chmod 775 $reg_name && \
    mv $reg_name $root/bin/reg
RUN $root/bin/reg version

# ripgrep
ENV ripgrep_name ripgrep-${ripgrep_version}-x86_64-unknown-linux-musl
ENV ripgrep_url https://github.com/BurntSushi/ripgrep/releases/download/$ripgrep_version/$ripgrep_name.tar.gz
RUN curl -LO "$ripgrep_url" && \
    tar xvzof $ripgrep_name.tar.gz && \
    mv $ripgrep_name/rg $root/bin/ && \
    rm -fr $ripgrep_name.tar.gz $ripgrep_name
RUN $root/bin/rg --version

# starship
ENV starship_name starship-x86_64-unknown-linux-musl
ENV starship_url https://github.com/starship/starship/releases/download/v$starship_version/$starship_name.tar.gz
RUN curl -LO "$starship_url" && \
    tar xvzof $starship_name.tar.gz && \
    chmod 775 starship && \
    mv starship $root/bin/ && \
    rm -fr $starship_name.tar.gz
RUN $root/bin/starship -V

# stern
ENV stern_name stern_linux_amd64
ENV stern_url https://github.com/wercker/stern/releases/download/$stern_version/$stern_name
RUN curl -LO "$stern_url" && \
    chmod 775 $stern_name && \
    mv $stern_name $root/bin/stern
RUN $root/bin/stern --version

# yank
ENV yank_name yank-${yank_version}
ENV yank_url https://github.com/mptre/yank/releases/download/v${yank_version}/${yank_name}.tar.gz
RUN curl -LO "$yank_url" && \
    tar xvzf $yank_name.tar.gz && \
    cd $yank_name && \
    make && \
    mv yank $root/bin/ && \
    cd .. && \
    rm -fr $yank_name.tar.gz $yank_name
RUN $root/bin/yank -v

# yj
ENV yj_name yj-linux
ENV yj_url https://github.com/sclevine/yj/releases/download/v$yj_version/$yj_name
RUN curl -LO "$yj_url" && \
    chmod 775 $yj_name && \
    mv $yj_name $root/bin/yj
RUN $root/bin/yj -v

# zoxide
ENV zoxide_name zoxide-x86_64-unknown-linux-musl
ENV zoxide_url https://github.com/ajeetdsouza/zoxide/releases/download/v$zoxide_version/$zoxide_name
RUN curl -LO "$zoxide_url" && \
    chmod 775 $zoxide_name && \
    mv $zoxide_name $root/bin/zoxide
RUN $root/bin/zoxide --version

FROM debian:stable-slim

LABEL io.rafi.source="https://github.com/rafi/awesome-cli-binaries"
LABEL io.rafi.revision="34"

COPY --from=builder $root/bin $root

#  vim: set ts=2 sw=4 tw=80 et :
