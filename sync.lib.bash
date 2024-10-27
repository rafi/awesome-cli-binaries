#!/usr/bin/env bash
set -euo pipefail
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!! This will overwrite files in ~/.config !!!!
# -----------------------------------------------
# This file is being sourced by sync.sh --
# and should NOT be used by itself!

# shellcheck disable=SC2016
function _intro() {
	echo "Rafi's rootless work setup"
	echo '~ USE AT YOUR OWN RISK  ~'
  echo '         ______         '
  echo '      .-"      "-.      '
  echo '     /            \     '
  echo '    |              |    '
  echo '    |,  .-.  .-.  ,|    '
  echo '    | )(__/  \__)( |    '
  echo '    |/     /\     \|    '
  echo '    (_     ^^     _)    '
  echo '     \__|IIIIII|__/     '
  echo '      | \IIIIII/ |      '
  echo '      \          /      '
  echo 'jgs    `--------`       '
	echo
	echo 'This will overwrite existing files in (if any):'
	echo '  ~/.config files:'
	echo '    https://github.com/rafi/awesome-cli-binaries/tree/master/.files'
	echo '  ~/.local/bin files:'
	echo '    https://github.com/rafi/awesome-cli-binaries?tab=readme-ov-file#binaries'
	echo
}

# Bootstrap a remote host.
function _init_machine() {
	mkdir -p ~/.config ~/.cache ~/.local/opt

	# Persist custom bashrc import in ~/.bashrc
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

	# Install fish, unless --no-fish is passed.
	if [[ "$*" == *"--no-fish"* ]]; then
		rm -f ~/.local/bin/fish ~/.local/bin/fish_*
	else
		if [ -f ~/.local/bin/fish ] && [ ! -d ~/.local/share/fish/install ]; then
			~/.local/bin/fish --install=noconfirm || echo >&2 'fish already installed?'
		fi
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
			pushd "$apps_path/$name" 1>/dev/null || return
			cp -f "$file_path" ./
			./"${app_image}" --appimage-extract 1>/dev/null
			ln -vfs "${PWD}"/squashfs-root/AppRun "$HOME"/.local/bin/"${name}"
			rm -rf ./"${app_image}"
			popd 1>/dev/null || return
		done
	fi
}

# Detects the machine architecture.
function _detect_arch() {
	case "$(uname -m)" in
		i386|i686) echo '386' ;;
		arm|armv7l) echo 'arm' ;;
		arm64|aarch64) echo 'arm64' ;;
		x86_64) echo 'amd64' ;;
		*) lscpu | awk '/Architecture:/{print $2}' ;;
	esac
}

# Downloads binaries by extracting from container image via crane.
function _download_binaries() {
	local tmpdir; tmpdir="$(mktemp -d -t 'init.rafi.io.XXXXXXX')"
	echo ":: Temporary directory: '$tmpdir'"
	cd "$tmpdir" || { echo >&2 "Unable to cd '$tmpdir'"; exit 1; }

	echo ':: Download crane…'
	local crane_repo=google/go-containerregistry
	local crane_file
	crane_file="go-containerregistry_$(uname -s)_$([ "$__arch" = amd64 ] && uname -m || echo "$__arch").tar.gz"
	wget -qO- --no-cookie \
		"https://github.com/$crane_repo/releases/latest/download/$crane_file" \
		| tar xzf - crane && chmod 770 crane

	echo ':: Download and export image…'
	./crane export rafib/awesome-cli-binaries - \
		| tar xf - usr/local/bin root/.config

	echo ':: Setup binaries at ~/.local/bin/'
	mv -f usr/local/bin/* ~/.local/bin/
	echo ':: Setup config files at ~/.config/'
	cp -rf root/.config/* ~/.config/
	cd ~ || { echo >&2 'Unable to cd ~, aborting.'; exit 1; }
	rm -rf "$tmpdir"
}

# Run on remote: Download binaries and ~/.config files.
function _run_if_executed_directly() {
	local __arch; __arch="$(_detect_arch)"
	if [ ! "$__arch" = 'amd64' ] && [ ! "$__arch" = 'arm64' ]; then
		echo >&2 'ERROR: Only Linux amd64/arm64 architecture is currently supported.'
		exit 1
	fi

	_intro

	mkdir -p ~/.config ~/.cache ~/.local/bin ~/.local/opt

	_download_binaries
	_init_machine "$@"

	echo "\\"
	echo ' | Done, run "source ~/.bashrc" or restart terminal to apply changes.'
	echo ' | Enjoy!'
	echo '/'
}

# Run script, unless it's sourced.
(return 0 2>/dev/null) || _run_if_executed_directly "$@"
