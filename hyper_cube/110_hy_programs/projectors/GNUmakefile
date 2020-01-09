
INSTALL_DIR = $(PREFIX)/bin

BUILD := hy_projectors_on hy_projectors_off

INSTALLED := hy_projectors_common.rb

hy_getRootWidth_SOURCES := hy_getRootWidth.c

hy_getRootWidth_LDFLAGS = -lX11


hy_projectors_on: hy_projectors_on_off.rb
	echo "#!/usr/bin/ruby -w" > $@
	echo "# This is a generated file" >> $@
	sed $^ -e 's/@on@/on/g' -e 's/@CMD@/POWR1/g' >> $@
	chmod 755 $@

hy_projectors_off: hy_projectors_on_off.rb
	echo "#!/usr/bin/ruby -w" > $@
	echo "# This is a generated file" >> $@
	sed $^ -e 's/@on@/off/g' -e 's/@CMD@/POWR0/g' >> $@
	chmod 755 $@


include ../quickbuild.make
