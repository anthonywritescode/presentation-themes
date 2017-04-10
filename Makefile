THEMES := $(wildcard themes/*.scss)
THEMES_MAKE := $(patsubst themes/%.scss,make-%,$(THEMES))

all: $(THEMES_MAKE)

test:
	mkdir -p test

test/%: | test
	mkdir -p $@/assets
	touch $@/assets/_app.scss
	cd $@ && ln -s ../../example-slides.md slides.md
	cd $@/assets && ln -s ../../../themes/$*.scss _theme.scss

venv: requirements.txt
	rm -rf venv
	virtualenv venv -ppython3.6
	venv/bin/pip install -rrequirements.txt

.PHONY: make-%
make-%: test/% venv
	cd $< && ../../venv/bin/markdown-to-presentation run-build

clean:
	rm -rf test venv

.SECONDARY:
