IMAGE:=rafib/awesome-cli-binaries
TAR:=tar
OUT:=.bin
.PHONY: docker all
.DEFAULT:

TARGETS:=bandwhich bat bottom chafa dua duf dust dyff fd fzf glow heksa hexyl hyperfine jq lf mkcert ncdu nvim.appimage reg rg starship stern tmux yank xh yj zoxide

all: $(TARGETS)

$(OUT):
	install -dm755 $@

dist: $(TARGETS) static.tar.xz

static.tar.xz:
	(cd $(OUT) && tar cvf ../static.tar $(TARGETS))
	xz -T0 -v9 static.tar

docker:
	mkdir -p $(OUT)
	docker build -t $(IMAGE) .

$(TARGETS): docker
	docker run --rm -a stdout $(IMAGE) /bin/tar -cf - /opt/bin/$@ | $(TAR) xf - --strip-components=2 -C $(OUT)

clean:
	-(cd $(OUT) && rm $(TARGETS))

distclean: clean
	-rm static.tar.xz

dockerclean:
	docker rmi -f $(IMAGE)
