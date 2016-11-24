THIS:=$(realpath $(lastword $(MAKEFILE_LIST)))
REPO_ROOT_DIR:=$(dir $(THIS))
UTILS:=$(realpath $(REPO_ROOT_DIR)/scripts/utils.sh)
INSTALL_DIR:=$(DESTDIR)/usr/share/themes


all: gresource

changes:
	$(UTILS) changes $(REPO_ROOT_DIR)

clean:
	$(UTILS) clean $(REPO_ROOT_DIR)

create-dist:
	$(UTILS) create-dist $(REPO_ROOT_DIR)

css: clean create-dist
	$(UTILS) css $(REPO_ROOT_DIR)

_gresource: css
	$(UTILS) gresource $(REPO_ROOT_DIR)

gresource: _gresource remove-scss-dist

_install:
	$(UTILS) install $(REPO_ROOT_DIR) $(INSTALL_DIR)

install: all _install

remove-scss-dist:
	$(UTILS) remove-scss-dist $(REPO_ROOT_DIR)

uninstall:
	$(UTILS) uninstall $(REPO_ROOT_DIR) $(INSTALL_DIR)

zip: all
	mkdir $(REPO_ROOT_DIR)/dist
	$(UTILS) install $(REPO_ROOT_DIR)/dist/$$(basename $(INSTALL_DIR))
	cd $(REPO_ROOT_DIR)/dist && zip --symlinks -rq $$(basename $(INSTALL_DIR)) $$(basename $(INSTALL_DIR))


.PHONY: all changes clean create-dist css _gresource gresource
.PHONY: _install install remove-scss-dist watch uninstall zip

.DEFAULT_GOAL := all

# vim: set ts=4 sw=4 tw=0 noet :
