IMAGE:=rafib/awesome-cli-binaries
TAR:=tar
OUT:=.bin
.PHONY: docker all
.DEFAULT:

TARGETS:=bat chafa duf dyff fd fzf glow heksa hexyl ht jq kubectl-fuzzy lf mkcert ncdu reg rg starship stern tmux yank yj zoxide

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
	docker run -a stdout $(IMAGE) /bin/tar -cf - /opt/bin/$@ | $(TAR) xf - --strip-components=2 -C $(OUT)

clean:
	-(cd $(OUT) && rm $(TARGETS))

distclean: clean
	-rm static.tar.xz

dockerclean:
	docker rmi -f $(IMAGE)
