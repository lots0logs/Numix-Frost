REPO_ROOT_DIR=$(shell pwd)
REPO_DIRNAME=$(shell basename $(REPO_ROOT_DIR))
DIST_DIR=$(REPO_ROOT_DIR)/dist/$(REPO_DIRNAME)
SRC_DIR=$(REPO_ROOT_DIR)/src

SRC_DIR_GTK=$(SRC_DIR)/toolkits/gtk-3.0
SRC_DIR_GTK320=$(SRC_DIR)/toolkits/gtk-3.20
SRC_DIR_CINNAMON=$(SRC_DIR)/desktops/cinnamon
SRC_DIR_GNOME=$(SRC_DIR)/desktops/gnome-shell

DIST_DIR_GTK=$(DIST_DIR)/gtk-3.0
DIST_DIR_GTK320=$(DIST_DIR)/gtk-3.20
DIST_DIR_CINNAMON=$(DIST_DIR)/cinnamon
DIST_DIR_GNOME=$(DIST_DIR)/gnome-shell

INSTALL_DIR=$(DESTDIR)/usr/share/themes/Numix-Frost

COMPILE_RESOURCES=glib-compile-resources
SASS=scss
SASSFLAGS=--sourcemap=none
UTILS=scripts/utils.sh

# Hack to make our variables available in utils script without passing them individually.
MAKE_ENV := $(shell echo '$(.VARIABLES)' | awk -v RS=' ' '/^[a-zA-Z0-9_]+$$/')
SHELL_EXPORT := $(foreach v,$(MAKE_ENV),$(v)='$($(v))')


all: gresource


changes:
	$(UTILS) changes


clean:
	@$(SHELL_EXPORT) $(UTILS) clean


create-dist:
	@$(SHELL_EXPORT) $(UTILS) create-dist


css: clean create-dist
	@$(SHELL_EXPORT) $(UTILS) css


_gresource: css
	@$(SHELL_EXPORT) $(UTILS) _gresource


gresource: _gresource remove-scss-dist


install: all
	@$(SHELL_EXPORT) $(UTILS) install


remove-scss-dist:
	rm -rf $(SRC_DIR_GTK)/dist $(SRC_DIR_GTK320)/dist $(SRC_DIR_CINNAMON)/dist


watch: clean
	while true; do \
		make gresource; \
		inotifywait @gtk.gresource -qr -e modify -e create -e delete $(RES_DIR); \
	done


uninstall:
	rm -rf $(INSTALL_DIR)


zip: all
	mkdir $(REPO_ROOT_DIR)/dist
	$(UTILS) install $(REPO_ROOT_DIR)/dist/$$(basename $(INSTALL_DIR))
	cd $(REPO_ROOT_DIR)/dist && zip --symlinks -rq $$(basename $(INSTALL_DIR)) $$(basename $(INSTALL_DIR))



.PHONY: all changes clean create-dist css _gresource gresource
.PHONY: install remove-scss-dist watch uninstall zip

.DEFAULT_GOAL := all

# vim: set ts=4 sw=4 tw=0 noet :
