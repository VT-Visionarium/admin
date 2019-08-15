#!/bin/bash

set -ex
cd $(dirname ${BASH_SOURCE[0]})

tag=v6.5-snapshot
tarfile=github_castle-engine-${tag}.tgz
url=https://github.com/castle-engine/castle-engine/tarball/$tag

if [ -e src ] ; then
    set +x
    echo "FAIL: src exists"
    exit 1
fi


if [ ! -f "$tarfile" ] ; then
    wget -O $tarfile $url
fi

mkdir src
cd src

tar -xzf ../$tarfile --strip-components=1

cd packages
lazbuild --build-all castle_base.lpk
