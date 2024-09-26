#!/usr/bin/env bash
set -eu
_VERSION='0.11.0'

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
			echo -e "\nexport PATH=\"${apps_path}/${name}/bin:\$PATH\"" >> ~/.config/bash/exports
		fi
	done

	# Install fish
	if [ -f ~/.local/bin/fish ] && [ ! -d ~/.local/share/fish/install ]; then
		~/.local/bin/fish --install=noconfirm || echo >&2 'fish already installed?'
	fi

	# Install appimages
	if test -f "$HOME"/.local/bin/*.appimage; then
		for file_path in "$HOME"/.local/bin/*.appimage; do
			app_image="${file_path##*/}"
			name="${app_image%%.*}"
			if [ -z "$name" ] || [ -z "$app_image" ]; then
				echo >&2 "ERROR Failed to parse appimage name from '${file_path}'"
				continue
			fi
			test -d "${apps_path}/${name}" && rm -rf "${apps_path:?}/${name}"
			mkdir "$apps_path/$name"
			pushd "$apps_path/$name" 1>/dev/null
			cp -f "$file_path" ./
			./"${app_image}" --appimage-extract 1>/dev/null
			ln -vfs "${PWD}"/squashfs-root/AppRun "$HOME"/.local/bin/"${name}"
			rm -rf ./"${app_image}"
			popd 1>/dev/null
		done
	fi
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
