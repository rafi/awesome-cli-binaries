#!/usr/bin/env sh
set -eu

# shellcheck disable=SC2016
_intro() {
	echo
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
_init_machine() {
	mkdir -p ~/.config ~/.cache ~/.local/opt

	# Persist custom bashrc import in ~/.bashrc
	custom_bashrc='.config/bash/bashrc'
	if test -f ~/.bashrc && ! grep -q "$custom_bashrc" ~/.bashrc; then
		# shellcheck disable=SC2016
		printf '\n[ -f %s ] && . %s\n' \
			'$HOME/'"$custom_bashrc" '$HOME/'"$custom_bashrc" \
			>> ~/.bashrc
	fi

	# Extract archives in ~/.local/opt and persist PATH
	apps_path="$HOME/.local/opt"
	for archive in "$HOME"/.local/bin/*tar.gz; do
		name="${archive##*/}"
		name="${name%%.*}"
		app_path="$apps_path/$name"
		if [ -d "$app_path" ]; then
			rm -rf "${apps_path:?}/${name}"
		fi
		tar -C "$apps_path" -xzf "$archive"
		if [ -d "$app_path" ] && ! grep -q "$app_path" ~/.config/bash/exports; then
			# shellcheck disable=SC2016
			printf '\nexport PATH="%s:$PATH"\n' "$app_path/bin" \
				>> ~/.config/bash/exports
		fi
	done

	verbose="${VERBOSE:-0}"
	skip_fish="${SKIP_FISH:-0}"
	for arg; do
		case "$arg" in
			--no-fish) skip_fish=1;;
			-h|-\?|--help) info; exit;;
			-v|--verbose) verbose=$((verbose + 1));;
			-?*) printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2;;
		esac
		shift
	done

	# Install fish, unless --no-fish is passed.
	fish_bin=~/.local/bin/fish
	if [ "$skip_fish" = '1' ]; then
		rm -f "$fish_bin" "$fish_bin"_*
	else
		if [ -f "$fish_bin" ] && [ ! -d ~/.local/share/fish/install ]; then
			"$fish_bin" --install=noconfirm || echo >&2 'fish already installed?'
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
			cd "$apps_path/$name" || { echo >&2 'Error cd'; exit 1; }
			cp -f "$file_path" ./
			./"${app_image}" --appimage-extract 1>/dev/null
			ln -vfs "${PWD}"/squashfs-root/AppRun "$HOME"/.local/bin/"${name}"
			rm -rf ./"${app_image}"
			cd - || { echo >&2 'Error running cd -'; exit 1; }
		done
	fi
}

# Detects the machine architecture.
_detect_arch() {
	case "$(uname -m)" in
		i386|i686) echo '386' ;;
		arm|armv7l) echo 'arm' ;;
		arm64|aarch64) echo 'arm64' ;;
		x86_64) echo 'amd64' ;;
		*) lscpu | awk '/Architecture:/{print $2}' ;;
	esac
}

# Downloads binaries by extracting from container image via crane.
_download_binaries() {
	tmpdir="$(mktemp -d -t 'init.rafi.io.XXXXXXX')"
	echo ":: Temporary directory: '$tmpdir'"
	cd "$tmpdir" || { echo >&2 "Unable to cd '$tmpdir'"; exit 1; }

	echo ':: Download crane…'
	crane_repo=google/go-containerregistry
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
_main() {
	__arch="$(_detect_arch)"
	if [ ! "$__arch" = 'amd64' ] && [ ! "$__arch" = 'arm64' ]; then
		echo >&2 'ERROR: Only Linux amd64/arm64 architecture is currently supported.'
		exit 1
	fi

	_intro

	mkdir -p ~/.config ~/.cache ~/.local/bin ~/.local/opt

	if [ ! "${SKIP_DOWNLOAD:-}" = "1" ]; then
		_download_binaries
	fi

	_init_machine "$@"

	echo "\\"
	echo ' | Done, run "source ~/.bashrc" or restart terminal to apply changes.'
	echo ' | Enjoy!'
	echo '/'
}

_main "$@"
