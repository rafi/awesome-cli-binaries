IMAGE := 'rafib/awesome-cli-binaries'
OUT   := 'bin'

export BUILD_TOKEN := env_var_or_default('GITHUB_TOKEN', env_var_or_default('HOMEBREW_GITHUB_API_TOKEN', ''))

[private]
default:
  @just --list --unsorted

[private]
validate:
  @if [ "${BUILD_TOKEN:-}" = "" ]; then \
    echo '[ERROR] You must export GITHUB_TOKEN environment variable to' \
      'prevent rate-limiting.'; \
    exit 1; \
  fi

build: docker binaries
dist: build archive

# build docker image
docker: validate
  docker buildx build \
    --platform linux/amd64 \
    --secret id=token,env=BUILD_TOKEN \
    --cache-from type=local,src=./.cache \
    --cache-to type=local,dest=./.cache \
    --load \
    -t {{ IMAGE }} .

# copy binaries locally
binaries:
  docker run --rm --platform linux/amd64 -v $PWD:/artifacts \
    {{ IMAGE }} cp -r /usr/local/bin /artifacts

# compress local binaries
archive:
  (cd "{{ OUT }}" && tar cvf ../static.tar *)
  xz -T0 -v9 static.tar

# sync local binaries to remote hosts
sync +hosts:
  #!/usr/bin/env bash -eu
  for HOST in {{ hosts }}; do
    rsync -rltzP --exclude '.git*' \
      --rsync-path='mkdir -p ~/.local/bin && rsync' \
      ./"{{ OUT }}"/* "${HOST}":./.local/bin/
  done

# erase local binaries
clean:
  -rm -rf ./"{{ OUT }}"

# erase local binaries and compressed archive
distclean: clean
  -rm static.tar.xz

# erase image and cache
dockerclean:
  -rm -rf $XDG_CACHE_HOME/buildkit/server-conf/*
  docker rmi -f {{ IMAGE }}
