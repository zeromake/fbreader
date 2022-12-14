include $(ROOTDIR)/makefiles/config.mk

INCLUDE = $(ZINCLUDE) $(EXTERNAL_INCLUDE)

HEADERS = $(wildcard *.h)
SOURCES_CPP = $(wildcard *.cpp)
SOURCES_OBJCPP = $(wildcard *.mm)
SOURCES_OBJC = $(wildcard *.m)
OBJECTS = $(patsubst %.cpp, %.o, $(SOURCES_CPP)) $(patsubst %.mm, %.o, $(SOURCES_OBJCPP)) $(patsubst %.m, %.o, $(SOURCES_OBJC))

.SUFFIXES: .cpp .M .m .o .h

.cpp.o:
	@echo -n 'Compiling $@ ...'
ifdef CFLAGS_NOARCH
	@$(CC) -MM $(CFLAGS_PRE) $(INCLUDE) $< -o `basename $< .cpp`.d
	@$(CC) -c $(CFLAGS) $(INCLUDE) $<
else
	@$(CC) -MMD -c $(CFLAGS) $(INCLUDE) $<
endif
	@echo ' OK'

ifneq "$(TARGET_ARCH)" "win32"
.M.o:
	@echo -n 'Compiling $@ ...'
ifdef CFLAGS_NOARCH
	@$(CC) -MM $(CFLAGS_PRE) $(INCLUDE) $< -o `basename $< .M`.d
	@$(CC) -c $(CFLAGS) $(INCLUDE) $<
else
	@$(CC) -MMD -c $(CFLAGS) $(INCLUDE) $<
endif
	@echo ' OK'
endif

.m.o:
	@echo -n 'Compiling $@ ...'
ifdef CFLAGS_NOARCH
	@$(CC) -MM $(CFLAGS_PRE) $(INCLUDE) $< -o `basename $< .m`.d
	@$(CC) -c $(CFLAGS) $(INCLUDE) $<
else
	@$(CC) -MMD -c $(CFLAGS) $(INCLUDE) $<
endif
	@echo ' OK'

all: $(OBJECTS)

clean:
	@$(RM) *.o *.s *.ld *.d

-include *.d
