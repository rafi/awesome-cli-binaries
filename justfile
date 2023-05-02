IMAGE := 'rafib/awesome-cli-binaries'
TAR   := 'tar'
OUT   := 'bin'

# list all recipes
[private]
default:
  @just --list --unsorted

build: docker
dist: docker archive

# build docker image and copy binaries locally
docker:
  -mkdir -p "{{ OUT }}"
  DOCKER_BUILDKIT=1 docker buildx build \
    --platform linux/amd64 \
    --secret id=token,env=HOMEBREW_GITHUB_API_TOKEN \
    --cache-to type=local,dest=.cache \
    --cache-from type=local,src=.cache \
    --load \
    -t {{ IMAGE }} .
  docker run --platform linux/amd64 --rm -a stdout {{ IMAGE }} \
    /bin/tar -cf - /usr/local/bin | {{ TAR }} xf - --strip-components=2

# archive local binaries and compress
archive:
  (cd "{{ OUT }}" && tar cvf ../static.tar *)
  xz -T0 -v9 static.tar

# sync local binaries to remote hosts
sync +hosts:
  #!/usr/bin/env bash -eu
  for host in {{ hosts }}; do
    rsync -rltzP --exclude '.git*' \
      --rsync-path='mkdir -p ~/.local/bin && rsync' \
      ./bin/* "$host":./.local/bin/
  done

# erase local binaries
clean:
  -rm -rf $(OUT)

# erase local binaries and compressed archive
distclean: clean
  -rm static.tar.xz

# erase image and cache
dockerclean:
  rm -rf .cache
  docker rmi -f {{ IMAGE }}
