
INSTALL_DIR = $(PREFIX)/bin


INSTALLED := hy_edgeBlank hy_edgeBlend_common hy_edgeBlend_off hy_edgeBlend_on

hy_blackEdge_SOURCES := hy_blackEdge.c

hy_blackEdge_CFLAGS = $(shell pkg-config gtk+-3.0 --cflags)
hy_blackEdge_LDFLAGS = $(shell pkg-config gtk+-3.0 --libs)


include ../quickbuild.make
