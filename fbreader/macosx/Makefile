ROOTDIR = $(CURDIR)/../..
include $(ROOTDIR)/makefiles/config.mk

SHARE_FBREADER = $(DESTDIR)$(SHAREDIR)/FBReader

install:
	# @strip $(DESTDIR)$(INSTALLDIR)/Contents/MacOS/*
	@install -d $(DESTDIR)$(INSTALLDIR)/Contents/Resources/Base.lproj
	@install -m 0644 Info.plist $(DESTDIR)$(INSTALLDIR)/Contents
	@install -m 0644 ../data/icons/application/FBReader.icns $(DESTDIR)$(INSTALLDIR)/Contents/Resources
	@install -m 0644 ../data/icons/application/FBReaderDocument.icns $(DESTDIR)$(INSTALLDIR)/Contents/Resources
	ibtool --errors --warnings --notices --output-format human-readable-text --compile $(DESTDIR)$(INSTALLDIR)/Contents/Resources/Base.lproj/MainMenu.nib $(ROOTDIR)/fbreader/macosx/Base.lproj/MainMenu.xib
	codesign --force --timestamp=none --deep --sign - $(DESTDIR)$(INSTALLDIR)
	@install -m 0644 ../data/default/config.macosx.xml $(SHARE_FBREADER)/default/config.xml
	@install -m 0644 ../data/default/keymap.macosx.xml $(SHARE_FBREADER)/default/keymap.xml
	@install -m 0644 ../data/default/styles.desktop.xml $(SHARE_FBREADER)/default/styles.xml
	@echo "APPL????" > $(DESTDIR)$(INSTALLDIR)/Contents/PkgInfo
