# AWESOME CLI BINARIES

IMAGE   := 'rafib/awesome-cli-binaries'
OUT     := 'bin'
OS_ARCH := if arch() == 'x86_64' { 'amd64' } else { 'arm64' }

export BUILD_TOKEN := env_var_or_default('GITHUB_TOKEN', env_var_or_default('HOMEBREW_GITHUB_API_TOKEN', ''))

_default:
  @just --list --unsorted

_validate:
  @if [ "${BUILD_TOKEN:-}" = "" ]; then \
    echo '[ERROR] You must export GITHUB_TOKEN environment variable to' \
      'prevent rate-limiting.'; \
    exit 1; \
  fi

build arch=OS_ARCH: (docker arch) (binaries arch)
dist arch=OS_ARCH: (build arch) (archive arch)

# build docker image
docker arch=OS_ARCH: _validate
  docker buildx build \
    --platform linux/{{ arch }} \
    --secret id=token,env=BUILD_TOKEN \
    --cache-from=rafib/awesome-cli-binaries \
    --load --progress=plain \
    -t {{ IMAGE }} .

# build and push multi-arch release. does not load locally.
release: _validate
  docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --cache-from=rafib/awesome-cli-binaries \
    --cache-from=type=local,mode=max,src=$HOME/.cache/buildx-cache \
    --cache-to=type=local,mode=max,dest=$HOME/.cache/buildx-cache \
    --secret id=token,env=BUILD_TOKEN \
    --push \
    -t {{ IMAGE }}:latest .

# copy binaries locally
binaries arch=OS_ARCH:
  docker run --rm --platform linux/{{ arch }} \
    -v "$PWD":/artifacts {{ IMAGE }} \
    cp -r /usr/local/bin /artifacts

# compress local binaries
archive arch=OS_ARCH: (binaries arch)
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

# erase container image
dockerclean:
  docker rmi -f {{ IMAGE }}
