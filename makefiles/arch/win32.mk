SHAREDIR = /share
IMAGEDIR = $(SHAREDIR)/icons
APPIMAGEDIR = $(IMAGEDIR)

SHAREDIR_MACRO = ~~\\\\share
IMAGEDIR_MACRO = $(SHAREDIR_MACRO)\\\\icons
APPIMAGEDIR_MACRO = $(IMAGEDIR_MACRO)

ZLSHARED = no

CC = x86_64-w64-mingw32-gcc
AR = ar rsu
LD = x86_64-w64-mingw32-g++
RESOURCE_COMPILER = windres

CFLAGS = -DUNICODE -D_WIN32_IE=0x0501 -D_WIN32_WINNT=0x0501 -DWINVER=0x0500 -DXMLCONFIGHOMEDIR=\"~\\\\..\"
#LDFLAGS = -mwindows
LDFLAGS = -mconsole

UILIBS = -lgdi32 -lcomctl32 -lcomdlg32 -lpng12 -ljpeg -lungif -ltiff
NETWORK_LIBS ?= -lcurl

RM = rm -rvf
RM_QUIET = rm -rf

BUILD_RESOURCE_OBJECT = yes

.resources:
	@echo -n 'Creating resource object...'
	@echo 'ApplicationIcon ICON data/icons/application/win32.ico' > $(TARGET).rc
	@echo '1 24 win32/manifest' >> $(TARGET).rc
	@$(RESOURCE_COMPILER) $(TARGET).rc -o src/$(TARGET)_rc.o
	@$(RM_QUIET) $(TARGET).rc
	@echo ' OK'
