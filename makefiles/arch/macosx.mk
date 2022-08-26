include $(ROOTDIR)/makefiles/arch/unix.mk

DESTDIR ?= $(ROOTDIR)/build

INSTALLDIR = /FBReader.app
BINDIR = $(INSTALLDIR)/Contents/MacOS
SHAREDIR = $(INSTALLDIR)/Contents/Share
IMAGEDIR = $(SHAREDIR)/icons
APPIMAGEDIR = $(SHAREDIR)/icons

SHAREDIR_MACRO = ~~/Contents/Share
IMAGEDIR_MACRO = $(SHAREDIR_MACRO)/icons
APPIMAGEDIR_MACRO = $(SHAREDIR_MACRO)/icons


ZLSHARED = no

TOOLSPATH = /Developer/usr/bin
OSXSDK = /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
CC = clang
AR = ar rsu
LD = clang

#ARCH_FLAGS = -arch x86_64 -arch i386 -arch ppc7400 -arch ppc64
ARCH_FLAGS = -arch x86_64
CFLAGS_NOARCH = -isysroot $(OSXSDK)
CFLAGS = $(ARCH_FLAGS) $(CFLAGS_NOARCH)
LDFLAGS = $(ARCH_FLAGS) \
	-isysroot $(OSXSDK)
EXTERNAL_INCLUDE = -I /usr/local/include -I $(OSXSDK)/usr/include -I $(ROOTDIR)/libs/macosx/include
EXTERNAL_LIBS = -liconv -L $(ROOTDIR)/libs/macosx/lib64

UILIBS = -framework Appkit $(ROOTDIR)/zlibrary/ui/src/cocoa/application/CocoaWindow.o $(ROOTDIR)/zlibrary/ui/src/cocoa/library/ZLCocoaAppDelegate.o

RM = rm -rvf
RM_QUIET = rm -rf
