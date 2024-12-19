#!/usr/bin/env sh
set -eu

_intro() {
	repo=https://github.com/rafi/awesome-cli-binaries
	echo
	echo "  ⠀⢀⣠⣤⣤⣄⡀⠀ Rafi's rootless workspace setup"
	echo '  ⣴⣿⣿⣿⣿⣿⣿⣦                                '
	echo '  ⣿⣿⣿⣿⣿⣿⣿⣿    # USE AT YOUR OWN RISK #    '
	echo '  ⣇⠈⠉⡿⢿⠉⠁⢸                                '
	echo '  ⠙⠛⢻⣷⣾⡟⠛⠋  Overwrites files in:          '
	echo '  ⠀⠀⠀⠈⠁⠀⠀⠀                                '
	echo '              ~/.config'
	echo "                $repo/tree/master/.files"
	echo '              ~/.local/bin'
	echo "                $repo?tab=readme-ov-file#binaries"
	echo
}

# Bootstrap a remote host.
_setup_bash() {
	# Persist custom bashrc import in ~/.bashrc
	custom_bashrc='.config/bash/bashrc'
	if test -f ~/.bashrc && ! grep -q "$custom_bashrc" ~/.bashrc; then
		echo ':: Update ~/.bashrc to source custom bashrc.'
		# shellcheck disable=SC2016
		printf '\n[ -f %s ] && . %s\n' \
			'$HOME/'"$custom_bashrc" '$HOME/'"$custom_bashrc" \
			>> ~/.bashrc
	fi
}

_extract_archives() {
	# Extract archives in ~/.local/opt and persist PATH
	apps_path="$HOME/.local/opt"
	for archive in "$HOME"/.local/bin/*tar.gz; do
		name="${archive##*/}"
		echo ":: Extract $name…"
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

	# Install appimages
	if test -f "$HOME"/.local/bin/*.appimage; then
		for file_path in "$HOME"/.local/bin/*.appimage; do
			app_image="${file_path##*/}"
			name="${app_image%%.*}"
			if [ -z "$name" ] || [ -z "$app_image" ]; then
				echo >&2 "ERROR Failed to parse appimage name from '${file_path}'"
				continue
			fi
			echo ":: Install $app_image…"
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

	echo ':: Download crane…'
	crane_repo=google/go-containerregistry
	crane_arch="$([ "$__arch" = amd64 ] && uname -m || echo "$__arch")"
	crane_file="go-containerregistry_$(uname -s)_$crane_arch.tar.gz"
	wget -qO- --no-hsts \
		"https://github.com/$crane_repo/releases/latest/download/$crane_file" \
		| tar xzf - -C "$tmpdir" crane && chmod 770 "$tmpdir"/crane

	echo ':: Download and export image…'
	# TODO: Does crane detect os/arch?
	"$tmpdir/crane" export --platform "linux/$__arch" \
		rafib/awesome-cli-binaries - \
		| tar xf - -C "$tmpdir" \
				usr/local/bin \
				root/.config \
				root/.local/share/nvim \
				root/.local/state/nvim

	if [ "$no_fish" = '1' ]; then
		rm -f "$tmpdir"/usr/local/bin/fish*
	fi

	echo ':: Setup binaries at ~/.local/bin/'
	mv -f "$tmpdir"/usr/local/bin/* ~/.local/bin/

	if [ "$no_config" = '0' ]; then
		echo ':: Setup config files at ~/.config/'
		mkdir -p ~/.local/share/nvim ~/.local/state/nvim
		cp -rf "$tmpdir"/root/.config/* ~/.config/
		cp -rf "$tmpdir"/root/.local/share/nvim/* ~/.local/share/nvim/
		cp -rf "$tmpdir"/root/.local/state/nvim/* ~/.local/state/nvim/
	fi

	# Clean
	rm -rf "$tmpdir"
}

_main() {
	__arch="$(_detect_arch)"
	if [ ! "$__arch" = 'amd64' ] && [ ! "$__arch" = 'arm64' ]; then
		echo >&2 'ERROR: Only Linux amd64/arm64 architecture is currently supported.'
		exit 1
	fi

	verbose="${VERBOSE:-0}"
	no_config="${NO_CONFIG:-0}"
	no_fish="${NO_FISH:-0}"
	no_intro="${NO_INTRO:-0}"
	for arg; do
		case "$arg" in
			--no-config) no_config=1;;
			--no-fish) no_fish=1;;
			-h|-\?|--help) exit;;
			-v|--verbose) verbose=$((verbose + 1));;
			-?*) printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2;;
		esac
		shift
	done

	[ "$no_intro" = '1' ] || _intro
	mkdir -p ~/.config ~/.cache ~/.local/bin ~/.local/opt
	if [ ! "${NO_DOWNLOAD:-}" = '1' ]; then
		_download_binaries
	fi
	_extract_archives
	[ "$no_config" = '1' ] || _setup_bash
	[ "$no_intro" = '1' ] || {
		echo "\\"
		echo ' | Done, run "source ~/.bashrc" or restart terminal to apply changes.'
		echo ' | Enjoy!'
		echo '/'
	}
}

_main "$@"
