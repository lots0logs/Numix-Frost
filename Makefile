SASS=scss
SASSFLAGS=--sourcemap=none
GLIB_COMPILE_RESOURCES=glib-compile-resources
RES_DIR=src/gtk-3.0
SCSS_DIR=$(RES_DIR)/scss
DIST_DIR=$(RES_DIR)/dist
RES_DIR320=src/gtk-3.20
SCSS_DIR320=$(RES_DIR320)/scss
DIST_DIR320=$(RES_DIR320)/dist
INSTALL_DIR=$(DESTDIR)/usr/share/themes/Numix-Frost
LATEST_STABLE_RELEASE=$(git describe --tags $(git rev-list --tags --max-count=1))

all: clean gresource

css:
	$(SASS) --update $(SASSFLAGS) $(SCSS_DIR):$(DIST_DIR)
	$(SASS) --update $(SASSFLAGS) $(SCSS_DIR320):$(DIST_DIR320)

gresource: css
	$(GLIB_COMPILE_RESOURCES) --sourcedir=$(RES_DIR) $(RES_DIR)/gtk.gresource.xml
	$(GLIB_COMPILE_RESOURCES) --sourcedir=$(RES_DIR320) $(RES_DIR320)/gtk.gresource.xml

watch: clean
	while true; do \
		make gresource; \
		inotifywait @gtk.gresource -qr -e modify -e create -e delete $(RES_DIR); \
	done

clean:
	rm -rf $(DIST_DIR)
	rm -f $(RES_DIR)/gtk.gresource
	rm -rf $(DIST_DIR320)
	rm -f $(RES_DIR320)/gtk.gresource

install: all
	$(UTILS) install $(INSTALL_DIR)

uninstall:
	rm -rf $(INSTALL_DIR)

changes:
	[ -f CHANGES ] && mv CHANGES CHANGES.old
	git log \
		--pretty=format:"[%ai] %<(69,trunc) %s %><(15) %aN {%h}" \
		--cherry-pick "${LATEST_STABLE_RELEASE}...HEAD" > CHANGES
	[ -f CHANGES.old ] && cat CHANGES.old >> CHANGES && rm CHANGES.old
	git add CHANGES
	git commit -m 'RELEASE PREP :: Update CHANGES file.'
	git push

.PHONY: all
.PHONY: css
.PHONY: watch
.PHONY: gresource
.PHONY: clean
.PHONY: install
.PHONY: uninstall
.PHONY: changes

.DEFAULT_GOAL := all

# vim: set ts=4 sw=4 tw=0 noet :
