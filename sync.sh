#!/usr/bin/env sh
set -eu
_VERSION='1.0.0'

# Show usage.
_usage() {
	echo "usage: ${0##*/} [-t|--tty] [-p|--port num] <server>..."
}

# Main entry point.
_main() {
	SSH_CMD=ssh
	hosts=''

	for arg; do
		case "$arg" in
			-t|--tty)       SSH_CMD="${SSH_CMD} -tt";;
			-p|--port)      shift; SSH_CMD="${SSH_CMD} -p $arg";;
			-h|--help)      _usage; exit ;;
			-v|--version)   echo "${0##*/} v${_VERSION}"; exit ;;
			-*) echo "Warning, unrecognized option $arg" >&2;;
			*) hosts="$hosts $arg";;
		esac
		shift
	done
	# shellcheck disable=SC2086
	set -- $hosts

	# Validate
	if [ -z "${1+set}" ]; then
		_usage
		exit 1
	fi

	for host; do
		echo ":: [${host}] copy dotfiles to remote"
		if ! rsync -rltz -e "${SSH_CMD}" ./.files/ "$host":./ || \
			! rsync -rltzP -e "${SSH_CMD}" ./bin "$host":./.local/
		then
			echo "[ERROR] failed rsync dotfiles to '${host}'" && exit 2
		fi

		echo ":: [${host}] bootstrap remote"
		${SSH_CMD} "$host" SKIP_DOWNLOAD=1 bash -s -- \
			< "$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"/sync.lib.bash

		echo ':: completed'
		shift
	done
}

_main "$@"
