#!/usr/bin/env bash
set -eu
_VERSION='0.9.0'

function _sync_usage() {
	echo "usage: ${0##*/} [-t|--tty] <server> [server]..."
}

function _bootstrap() {
	mkdir -p ~/.config ~/.cache ~/.local/bin ~/.local/share/lf

	# Add import of bash user config
	if ! grep -q '\.bash_user' ~/.bashrc; then
		echo -e "[ -f \$HOME/.bash_user ] && . \$HOME/.bash_user" >> ~/.bashrc
	fi

	# Install appimages (nvim)
	mkdir -p ~/.local/apps
	pushd "$HOME"/.local/apps 1>/dev/null
	for app_path in "$HOME"/.local/bin/*.appimage; do
		app_image="${app_path##*/}"
		app_name="${app_image%%.*}"
		if [ -n "$app_name" ] && [ -n "$app_image" ]; then
			rm -rf ./"$app_name"
			mkdir ./"$app_name"
			pushd ./"$app_name" 1>/dev/null
			cp -f "$app_path" ./
			./"${app_image}" --appimage-extract 1>/dev/null
			ln -vfs "${PWD}"/squashfs-root/AppRun "$HOME"/.local/bin/"${app_name}"
			rm -rf ./"${app_image}"
			popd 1>/dev/null
		fi
	done
	popd 1>/dev/null
}

function _run_remotely() {
	local _sudo="${3:-}"
	local _ssh=ssh
	[ "$FORCE_TTY" = "1" ] && _ssh="${_ssh} -tt"
	${_ssh} "${1}" "$_sudo bash -s" -- << EOF
		$(typeset -f "${2}")
		${2}
		exit
EOF
}

function _sync_main() {
	local FORCE_TTY=0
	local host='' hosts=()

	# Validate
	if [ -z "${1+set}" ]; then
		_sync_usage
		exit 2
	fi

	while [[ $# -gt 0 ]]; do
		case "${1}" in
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
			! rsync -rltzP --exclude '.git*' \
				--rsync-path='mkdir -p ~/.local/bin && rsync' \
				./bin/ "$host":./.local/bin/
		then
			echo "[ERROR] failed rsync dotfiles to '${host}'" && exit 3
		fi

		echo ":: [${host}] bootstrap remote"
		if ! _run_remotely "${host}" _bootstrap
		then
			echo "[ERROR] failed bootstrap on '${host}'" && exit 5
		fi

		echo ':: completed successfully'
	done
}

_sync_main "$@"
