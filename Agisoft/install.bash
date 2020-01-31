#!/bin/bash

set -exuo pipefail

PREFIX=/usr/local/encap/metashape-pro_1_6_1

cd "$(dirname ${BASH_SOURCE[0]})"

dir="$PWD"

#make metashape_MovePointer

tarfile=$PWD/metashape-pro_1_6_1_amd64.tar.gz

mkdir -p $PREFIX
tar --directory=$PREFIX --strip-components=1 -xzf $tarfile

cd $PREFIX
ls -1 > $PREFIX/encap.exclude


mkdir -p $PREFIX/bin

cd $dir
cp metashape $PREFIX/bin/
chmod 755 $PREFIX/bin/metashape
#cp metashape_MovePointer metashape_startx $PREFIX/bin
