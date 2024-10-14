#!/usr/bin/env bash
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# DO NOT RUN THIS UNLESS YOU UNDERSTAND THE CONSEQUENCES
# ------------------------------------------------------

# Bootstrap a remote host.
function _init_machine() {
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
			pushd "$apps_path/$name" 1>/dev/null || return
			cp -f "$file_path" ./
			./"${app_image}" --appimage-extract 1>/dev/null
			ln -vfs "${PWD}"/squashfs-root/AppRun "$HOME"/.local/bin/"${name}"
			rm -rf ./"${app_image}"
			popd 1>/dev/null || return
		done
	fi
}

# Downloads binaries by extracting from container image via crane.
function _download_binaries() {
	local tmpdir; tmpdir="$(mktemp -d -t 'rafi.XXXXXXX')"
	mkdir -p ~/.config ~/.local/bin
	echo ":: Created temporary directory '$tmpdir'"
	cd "$tmpdir" || exit

	wget -qO- https://github.com/google/go-containerregistry/releases/latest/download/go-containerregistry_Linux_x86_64.tar.gz \
		| tar xzf - crane && chmod 770 crane

	echo ':: Downloaded crane. Exporting image…'
	./crane export rafib/awesome-cli-binaries - | tar xf - usr/local/bin root/.config

	echo ':: Setup binaries at ~/.local/bin/'
	mv -f usr/local/bin/* ~/.local/bin/
	echo ':: Setup config files at ~/.config/'
	cp -rf root/.config/* ~/.config/
	cd ~ || exit
	rm -rf "$tmpdir"
	echo 'Done.'
}

# Run script, unless it's sourced.
(return 0 2>/dev/null) || { _download_binaries && _init_machine; }
