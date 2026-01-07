# === targets

# defaults
MENU := all clean test

# helpers
MENU += help readme

# main
MENU += serve clean

# load phony
.PHONY: $(MENU)

# === variables

# set default target
.DEFAULT_GOAL := help

# # set default shell to use
SHELL := /bin/bash

# === check make version

# enforce make 4+
# ifeq ($(origin .RECIPEPREFIX), undefined)
#   $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later. Use `brew install make` and run `gmake`)
# endif

# sets all lines in the recipe to be passed in a single shell invocation
.ONESHELL:

# === environment variables

# load dot.env file into environment (prepend hypen to skip if not found)
-include dot.env

# load current shell env vars into makefile shell env
export

# === main

##@ Helpers

help:														## display this help
	@awk 'BEGIN { FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"; } \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2; } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5); } \
		END { printf ""; }' $(MAKEFILE_LIST)

readme:													## show information and notes
	# === information and notes
	@touch README.md && cat README.md

##@ Menu

# core commands

serve: 													## serve project
	# === serve
	python3 -m http.server 9000

clean: 													## cleanup EVERYTHING except cname, makefile, and git
	# === clean
	# keep files: Makefile, README.md, CNAME, .nojekyll, .git, dot.env
	# removes: everything else (index.html, articles/, assets/, images/, svgs/, etc.)
	# root files
	rm -rf 404.html hashmap.json sitemap.xml index.html
	# remove images and svgs from root (user requested cleanup to move assets to right folder)
	rm -f wn*.png woodsnomad-logo.svg world-tree-life.svg
	# directories
	rm -rf articles/
	# wipe assets completely
	rm -rf assets/
