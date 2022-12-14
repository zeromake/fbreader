SHAREDIR = /share
IMAGEDIR = $(SHAREDIR)/icons
APPIMAGEDIR = $(IMAGEDIR)
DESTDIR ?= $(ROOTDIR)/build

SHAREDIR_MACRO = ~~\\\\share
IMAGEDIR_MACRO = $(SHAREDIR_MACRO)\\\\icons
APPIMAGEDIR_MACRO = $(IMAGEDIR_MACRO)

ZLSHARED = no

CC = x86_64-w64-mingw32-gcc
AR = ar rsu
LD = x86_64-w64-mingw32-g++
RESOURCE_COMPILER = windres

CFLAGS = -DUNICODE -D_WIN32_IE=0x0501 -D_WIN32_WINNT=0x0501 -DWINVER=0x0500 -DXMLCONFIGHOMEDIR=\"~\\\\..\" -DXMD_H -DFRIBIDI_LIB_STATIC -DCURL_STATICLIB -DPFD_HAS_IFILEDIALOG=0 -DWIN32_USE_DRAW_TEXT
#LDFLAGS = -mwindows
LDFLAGS = -mconsole

UILIBS = -L $(ROOTDIR)/3rd/lib -lgdi32 -lcomctl32 -lcomdlg32 -lpng -lgif -ltiff -ljpeg
NETWORK_LIBS ?= -lcurl -lcrypto -lssl -lbrotlienc-static -lidn2 -lssh2 -lgsasl -lnghttp2 -lbrotlicommon-static -lbrotlidec-static -lws2_32 -lcrypt32 -lwldap32
ARCHIVER_LIBS ?= -lzlib -lbzip2

RM = rm -rvf
RM_QUIET = rm -rf

BUILD_RESOURCE_OBJECT = yes

EXTERNAL_INCLUDE = -I $(ROOTDIR)/3rd/include

.resources:
	@echo -n 'Creating resource object...'
	@$(RESOURCE_COMPILER) win32/$(TARGET).rc -o src/$(TARGET)_rc.o
	@echo ' OK'
