IMAGE:=rafib/awesome-cli-binaries
TAR:=tar
OUT:=bin
.PHONY: docker all
.DEFAULT:

TARGETS:=bin

all: $(TARGETS)

$(OUT):
	install -dm755 $@

dist: $(TARGETS) static.tar.xz

static.tar.xz:
	(cd $(OUT) && tar cvf ../static.tar $(TARGETS))
	xz -T0 -v9 static.tar

docker:
	mkdir -p $(OUT)
	DOCKER_BUILDKIT=1 docker buildx build --secret id=token,env=HOMEBREW_GITHUB_API_TOKEN --platform linux/x86_64 -t $(IMAGE) .

$(TARGETS): docker
	docker run --platform linux/x86_64 --rm -a stdout $(IMAGE) /bin/tar -cf - /usr/local/bin | $(TAR) xf - --strip-components=2

clean:
	-(cd $(OUT) && rm $(TARGETS))

distclean: clean
	-rm static.tar.xz

dockerclean:
	docker rmi -f $(IMAGE)
