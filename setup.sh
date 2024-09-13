#!/usr/bin/env bash
set -eu
_VERSION='0.10.0'

# Show usage.
function _usage() {
	echo "usage: ${0##*/} [-t|--tty] [-p|--port num] <server>..."
}

# Bootstrap a remote host.
function _bootstrap() {
	mkdir -p ~/.config ~/.cache ~/.local/opt

	# Persist custom ~/.bash_user import in ~/.bashrc
	if ! grep -q 'config\/bash\/bashrc' ~/.bashrc; then
		echo -e "\n[ -f \$HOME/.config/bash/bashrc ] && . \$HOME/.config/bash/bashrc" >> ~/.bashrc
	fi

	# Extract archives in ~/.local/opt and persist PATH
	local apps_path="$HOME/.local/opt"
	for archive in "$HOME"/.local/bin/*tar.gz; do
		name="${archive##*/}"
		name="${name%%.*}"
		if [ -d "${apps_path}/${name}" ]; then
			rm -rf "${apps_path:?}/${name}"
		fi
		tar -C "$apps_path" -xzf "$archive"
		if [ -d "${apps_path}/${name}" ]; then
			echo -e "\nexport PATH=\"\$PATH:${apps_path}/${name}/bin\"" >> ~/.config/bash/exports
		fi
	done
}

# Run a function remotely.
function _run_remotely() {
	${SSH_CMD} "${1}" "${3:-} bash -s" -- << EOF
		$(typeset -f "${2}")
		${2}
		exit
EOF
}

# Main entry point.
function _main() {
	local SSH_CMD=ssh
	local host='' hosts=()

	while [[ $# -gt 0 ]]; do
		case "${1}" in
			-t|--tty)       SSH_CMD="${SSH_CMD} -tt"; shift ;;
			-p|--port)      shift; SSH_CMD="${SSH_CMD} -p ${1}"; shift ;;
			-h|--help)      _usage; exit ;;
			-v|--version)   echo "${0##*/} v${_VERSION}"; exit ;;
			-*) echo "Warning, unrecognized option ${1}" >&2; shift ;;
			*) hosts+=("$1"); shift ;;
		esac
	done
	set -- "${hosts[@]}"

	# Validate
	if [ -z "${1+set}" ]; then
		_usage
		exit 1
	fi

	for host
	do
		echo ":: [${host}] copy dotfiles to remote"
		if ! rsync -rltz -e "${SSH_CMD}" ./.files/ "$host":./ || \
			! rsync -rltzP -e "${SSH_CMD}" ./bin "$host":./.local/
		then
			echo "[ERROR] failed rsync dotfiles to '${host}'" && exit 2
		fi

		echo ":: [${host}] bootstrap remote"
		if ! _run_remotely "${host}" _bootstrap
		then
			echo "[ERROR] failed bootstrap on '${host}'" && exit 3
		fi

		echo ':: completed successfully'
	done
}

_main "$@"
