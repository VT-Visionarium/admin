
# do not recure into the console directory
SUBDIRS := .

INSTALL_DIR = $(PREFIX)/bin

INSTALLED :=\
 hy_frameLock_off\
 hy_frameLock_on\
 hy_start\
 hy_stop\
 hy_demoServer\
 hy_syncToVBlank_on\
 hy_syncToVBlank_off


IN_VARS := HOST

HOST := $(shell hostname -s).$(shell domainname)

hy_checkXRunning_SOURCES := hy_checkXRunning.c
hy_checkXRunning_CFLAGS = $(shell pkg-config gtk+-3.0 --cflags)
hy_checkXRunning_LDFLAGS = $(shell pkg-config gtk+-3.0 --libs)


include ../quickbuild.make
