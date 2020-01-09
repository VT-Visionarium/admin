
INSTALL_DIR = $(PREFIX)/bin

BUILD :=

INSTALLED := hy_startx hy_stopx hy_commonx


# if this is root user:
ifeq ($(shell id -u),0)
POST_INSTALL_COMMAND :=\
 cp xorg.conf.hy_1920x1200 xorg.conf.hy_2560x1600 /etc/X11/
#cp xinitrc /etc/X11/xinit/xinitrc
endif


include ../quickbuild.make
