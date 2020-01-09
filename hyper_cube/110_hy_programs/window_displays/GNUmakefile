
INSTALL_DIR = $(PREFIX)/bin

BUILD :=

INSTALLED := hy_startx hy_stopx hy_commonx


# if this user has sudo access and has set SUDO_INSTALL:
ifdef SUDO_INSTALL
POST_INSTALL_COMMAND :=\
 sudo cp xorg.conf.hy_1920x1200 xorg.conf.hy_2560x1600 /etc/X11/
#cp xinitrc /etc/X11/xinit/xinitrc
endif


include ../quickbuild.make
