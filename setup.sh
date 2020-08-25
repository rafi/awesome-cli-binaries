#!/usr/bin/env bash
set -eu
_VERSION='0.8.0'

function _sync_usage() {
	echo "usage: ${0##*/} [-t|--tty] [--root] <server> [server]..."
}

function _bootstrap() {
	mkdir -p ~/.config ~/.cache/vim ~/.local/bin ~/.local/share/lf

	# Add import of bash user config
	if ! grep -q '\.bash_user' ~/.bashrc; then
		echo -e "[ -f \$HOME/.bash_user ] && . \$HOME/.bash_user" >> ~/.bashrc
	fi

	# Sync files to root user, as-long as current user is NOT root
	if [ "$SETUP_ROOT" = "1" ] && [ "$EUID" -ne 0 ] && sudo -n echo -n 2>&1
	then
		# Setup kubectl completion
		local kubectl_completion=/usr/share/bash-completion/completions/kubectl
		if hash kubectl 2>/dev/null && [ ! -f "$kubectl_completion" ]; then
			echo ':: Exporting kubectl completions...'
			kubectl completion bash | sudo tee "$kubectl_completion"
			sudo chmod 644 "$kubectl_completion"
		fi

		local root_home="$(eval echo ~root)"
		echo ':: Copying files to root user...'
		sudo rsync -rlt \
			$HOME/.config $HOME/.vim $HOME/.bash_user \
			$HOME/.*ignore $HOME/.inputrc $HOME/.tmux*conf \
			"$root_home"/
		sudo rsync -rlt --progress $HOME/.local/bin "$root_home"/.local/
	fi
}

function _run_remotely() {
	local _sudo="${3:-}"
	local _ssh=ssh
	[ "$FORCE_TTY" = "1" ] && _ssh="${_ssh} -tt"
	${_ssh} "${1}" "SETUP_ROOT=${SETUP_ROOT} $_sudo bash -s" -- << EOF
		$(typeset -f "${2}")
		${2}
		exit
EOF
}

function _sync_main() {
	local FORCE_TTY=0 SETUP_ROOT=0
	local host='' hosts=()

	# Validate
	if [ -z "${1+set}" ]; then
		_sync_usage
		exit 2
	fi

	while [[ $# -gt 0 ]]; do
		case "${1}" in
			--root)         SETUP_ROOT=1; shift ;;
			-t|--tty)       FORCE_TTY=1; shift ;;
			-h|--help)      _sync_usage; exit ;;
			-v|--version)   echo "${0##*/} v${_VERSION}"; exit ;;
			-*) echo "Warning, unrecognized option ${1}" >&2; shift ;;
			*) hosts+=("$1"); shift ;;
		esac
	done
	set -- "${hosts[@]}"

	for host
	do
		echo ":: [${host}] copy dotfiles to remote"
		if ! rsync -rltz ./.files/ "$host":./ || \
			! rsync -rltzP --exclude '.git*' ./.bin/ "$host":./.local/bin/
		then
			echo "[ERROR] failed rsync dotfiles to '${host}'" && exit 3
		fi

		echo ":: [${host}] bootstrap remote"
		if ! _run_remotely "${host}" _bootstrap
		then
			echo "[ERROR] failed bootstrap on '${host}'" && exit 5
		fi

		if [ "$SETUP_ROOT" = "1" ]; then
			echo ":: [${host}] bootstrap remote's root user"
			if ! _run_remotely "${host}" _bootstrap sudo
			then
				echo "[ERROR] failed bootstrap on '${host}' sudo user" && exit 6
			fi
		fi
		echo ':: completed successfully'
	done
}

_sync_main "$@"
