ACLOCAL_AMFLAGS = --install -I m4

SUBDIRS = lib src
DIST_SUBDIRS = lib src

if HAVE_UTILS
SUBDIRS += utils
endif

appicondir = $(datadir)/pixmaps
appicon_DATA = extras/logos/noximperii.png
Graphicsdir = $(datadir)/applications
Graphics_DATA = noximperii.desktop
appdatadir = $(datadir)/appdata
appdata_DATA = noximperii.appdata.xml
dist_pkgdata_DATA = noximperii-confupdate.sh

dist_man6_MANS = noximperii.6
dist_doc_DATA = AUTHORS README TODO LICENSE

DATA_ARCHIVE = ndata.zip
if HAVE_UTILS
MKSPR      = utils/mkspr/mkspr$(EXEEXT)
endif
NOXIMPERII	     = noximperii$(EXEEXT)

EXTRA_DIST = LICENSE extras noximperii.desktop noximperii.appdata.xml
CLEANFILES = $(DATA_ARCHIVE) $(NOXIMPERII)

.PHONY: docs utils help install-ndata

all-local: $(NOXIMPERII) VERSION

$(NOXIMPERII):
	@echo "  LN    $(NOXIMPERII)"
	$(LN_S) "src/$(NOXIMPERII)" "$(NOXIMPERII)"

VERSION: src/config.h
	echo $(VERSION) > $@

if HAVE_UTILS
utils: $(MKSPR)

$(MKSPR):
	$(MAKE) -C utils/mkspr

$(DATA_ARCHIVE): VERSION
	@echo " ZIP   $(DATA_ARCHIVE)"
	cd "$(top_srcdir)" && \
    zip -0r "$(abs_top_builddir)/$(DATA_ARCHIVE)" AUTHORS VERSION noximperii-confupdate.sh dat/
else
utils:

$(DATA_ARCHIVE):
	@echo "***"
	@echo "*** You must clone the full git repo to create $(DATA_ARCHIVE)"
	@echo "***"
	@false
endif

install-ndata: $(DATA_ARCHIVE)
	ndata="$(DESTDIR)$(ndata_path)"; \
	dir=$$(echo "$$ndata" | sed 's/\(.*\)[\/\\].*/\1/'); \
	echo " $(MKDIR_P) '$$dir'"; \
	$(MKDIR_P) "$$dir"; \
	echo " $(INSTALL_DATA) -c '$(DATA_ARCHIVE)' '$$ndata'"; \
	$(INSTALL_DATA) -c "$(DATA_ARCHIVE)" "$$ndata"

install-data-hook:
	if test -e $(top_srcdir)/dat && test -e $(top_srcdir)/dat/gfx; then \
	  $(MAKE) install-ndata; \
	fi

uninstall-hook:
	echo " rm -rf '$(DESTDIR)$(pkgdatadir)'"; \
	echo " rm -rf '$(docdir)'"; \
	rm -rf "$(DESTDIR)$(pkgdatadir)"
	rm -rf "$(docdir)"

docs:
	$(MAKE) -C docs

help:
	@echo "Possible targets are:"
	@echo "        all - builds everything"
	@echo "  ndata.zip - creates the ndata file"
	@echo "       docs - creates the doxygen documentation"
	@echo "      clean - removes binaries and object files"
	@echo "    install - installs Nox Imperii"
	@echo "  uninstall - removes previously installed files"
	@echo "  dist-gzip - creates a source tarball with gzip compression"
	@echo " dist-bzip2 - creates a source tarball with bzip2 compression"
	@echo "  distcheck - checks if the created tarball works properly"
	@echo "  distclean - does clean and removes files created by configure"
