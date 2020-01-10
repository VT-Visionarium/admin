
INSTALL_DIR = $(PREFIX)/bin

BUILD :=

INSTALLED :=\
 hy_startx\
 hy_stopx\
 hy_commonx\
 hy_xmessage_lr_screen_test

# if this user has sudo access and has set SUDO_INSTALL:
ifdef SUDO_INSTALL
POST_INSTALL_COMMAND := sudo cp xorg.conf.hy_2560x1600 /etc/X11/
endif


include ../quickbuild.make
