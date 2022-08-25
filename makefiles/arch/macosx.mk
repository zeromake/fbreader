include $(ROOTDIR)/makefiles/arch/unix.mk

DESTDIR ?= /Applications

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
CFLAGS_NOARCH = \
	-fmessage-length=0 -pipe -fpascal-strings -fasm-blocks \
	-mdynamic-no-pic -W -Wall \
	-isysroot $(OSXSDK) \
	-fvisibility=hidden -fvisibility-inlines-hidden \
	-gdwarf-2 -g
CFLAGS = $(ARCH_FLAGS) $(CFLAGS_NOARCH)
LDFLAGS = $(ARCH_FLAGS) \
	-isysroot $(OSXSDK)
EXTERNAL_INCLUDE = -I /usr/local/include -I $(OSXSDK)/usr/include
EXTERNAL_LIBS = -liconv

UILIBS = -framework Appkit $(ROOTDIR)/zlibrary/ui/src/cocoa/application/CocoaWindow.o $(ROOTDIR)/zlibrary/ui/src/cocoa/library/ZLCocoaAppDelegate.o

RM = rm -rvf
RM_QUIET = rm -rf
