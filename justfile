IMAGE := 'rafib/awesome-cli-binaries'
OUT   := 'bin'
ARCH  := if arch() == 'x86_64' { 'amd64' } else { 'arm64' }

export BUILD_TOKEN := env_var_or_default('GITHUB_TOKEN', env_var_or_default('HOMEBREW_GITHUB_API_TOKEN', ''))

_default:
  @just --list --unsorted

_validate:
  @if [ "${BUILD_TOKEN:-}" = "" ]; then \
    echo '[ERROR] You must export GITHUB_TOKEN environment variable to' \
      'prevent rate-limiting.'; \
    exit 1; \
  fi

# Show system information.
info:
  @echo "Default build: linux/{{ ARCH }}"

build: docker binaries
dist: build archive

# build docker image
docker: _validate
  docker buildx build \
    --platform linux/{{ ARCH }} \
    --secret id=token,env=BUILD_TOKEN \
    --load \
    -t {{ IMAGE }} .

# build and release docker image
release: _validate
  docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --secret id=token,env=BUILD_TOKEN \
    --push \
    -t {{ IMAGE }} .

# copy binaries locally
binaries arch='amd64':
  docker run --rm --platform linux/{{ arch }} -v "$PWD":/artifacts {{ IMAGE }} \
    cp -r /usr/local/bin /artifacts

# compress local binaries
archive:
  (cd "{{ OUT }}" && tar cvf ../static.tar *)
  xz -T0 -v9 static.tar

# quick-sync to remote hosts, only local binaries
sync +hosts:
  for HOST in {{ hosts }}; do \
    rsync -rltzP --exclude '.git*' \
      --rsync-path='mkdir -p ~/.local/bin && rsync' \
      ./"{{ OUT }}"/* "$HOST":./.local/bin/; \
  done

# erase local binaries
clean:
  -rm -rf ./"{{ OUT }}"

# erase local binaries and compressed archive
distclean: clean
  -rm static.tar.xz

# erase image and cache
dockerclean:
  docker rmi -f {{ IMAGE }}
