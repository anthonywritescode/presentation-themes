THEMES := $(wildcard themes/*.scss)
THEME_FOLDERS := $(patsubst themes/%.scss,test/%,$(THEMES))

all: make-tests

test:
	mkdir -p test

test/%: test
	mkdir -p $@/assets
	touch $@/assets/_app.scss
	cd $@ && ln -s ../../example-slides.md slides.md
	cd $@/assets && ln -s ../../../themes/$*.scss _theme.scss

venv: requirements.txt
	rm -rf venv
	virtualenv venv -ppython3.6
	venv/bin/pip install -rrequirements.txt

.PHONY: make-tests
make-tests: $(THEME_FOLDERS) venv
	echo -n $(THEME_FOLDERS) | \
		xargs -d' ' --replace bash -c ' \
			cd {} && ../../venv/bin/markdown-to-presentation run-build \
		'

clean:
	rm -rf test venv
