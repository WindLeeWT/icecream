#!/bin/bash

set -e

basedir=$(cd `dirname $0`/..; pwd)

cd ${basedir}
./autogen.sh
./configure --prefix=/opt/icecream --with-libcap-ng=no --without-man --enable-gcc-show-caret=no
make -j4
echo "Icecream build successfully"

tardir="icecream.tarfiles"
tarbase="${tardir}/icecream"
rm -fr ${tarbase} && mkdir -p ${tarbase}
cd ${tarbase}
mkdir bin sbin lib64 scheduler
cd ${basedir}
chmod a+x client/icecc-create-env

cp client/icecc ${tarbase}/bin
cp client/icecc-create-env ${tarbase}/bin
cp daemon/iceccd ${tarbase}/sbin
cp scheduler/icecc-scheduler ${tarbase}/scheduler
# lzo library should be installed before compilation
cp /usr/lib64/liblzo2.so.2 ${tarbase}/lib64

cp scripts/iceccd.sh ${tarbase}/sbin
cp scripts/icecc-scheduler.sh ${tarbase}/scheduler
cp scripts/install.sh ${tarbase}

tar zcvf ${basedir}/icecream.tgz -C ${tardir} icecream
rm -fr ${tardir}
echo "Icecream tar successfully"
