# This is a GNU make file.

VERSION = 0.3
PREFIX ?= /usr/local/encap/PhotoScan-$(VERSION)

# These files are generated
built = metashape_MovePointer

# files installed in PREFIX/bin
bin = $(built)

metashape_MovePointer_LFLAGS = -lX11


build: $(built)

%: %.c
	$(CC) -Wall -Werror -g $($@_CFLAGS) $^ -o $@ $($@_LFLAGS)

install: $(built)
	mkdir -p $(PREFIX)/bin
	cp $(bin) metashape_startx $(PREFIX)/bin/

clean:
	rm -f $(built)

distclean: clean
