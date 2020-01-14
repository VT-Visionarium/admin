#!/bin/bash

# This script installs nodeJS from a tagged github.com repository.

set -exo pipefail

cd "$(dirname ${BASH_SOURCE[0]})"

make_opts="-j 24"

tag=v13.6.0


tarname=nodejs-$tag

url=https://github.com/nodejs/node/tarball/$tag

prefix=/usr/local/encap/$tarname

tarfile=$tarname.tar.gz

sha512sum=

case "$tag" in
    v13.6.0)
        sha512sum=f3142be0a426d4bdc62fd3689841c\
745fe4df49abf2a3225805e155dac5230fb8625eaa1631d\
36f7b575e0b9ffb63cdea4482c2ada0332adf7a05e70850\
e10bc
        ;;
esac


if [ ! -e "$tarfile" ] ; then
    wget $url -O $tarfile
fi

if [ -n "$sha512sum" ] ; then
    echo "$sha512sum  $tarfile" | sha512sum -c -
else
    set +x
    sha512sum $tarfile
    set -x
fi

try=0
while [ -d "${tarname}-try-$try" ] ; do
    let try=$try+1
done
builddir="${tarname}-try-$try"

mkdir "$builddir"
cd "$builddir"
tar --strip-components=1 -xzf ../$tarfile

./configure --prefix=$prefix
make $make_opts
make install

set +x
echo "SUCCESSFULLY installed $tarname in $prefix"
