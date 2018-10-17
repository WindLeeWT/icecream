#!/bin/bash

set -e

icecream_home="/opt/icecream"
basedir=$(cd `dirname $0`; pwd)

if [ "${basedir}" != "${icecream_home}" ]; then
    rm -fr ${icecream_home}
    cd ${basedir}/..
    cp -r icecream ${icecream_home}
fi

cd ${icecream_home}

ln -s -f ${icecream_home}/bin/icecc bin/icerun

icecc_path="libexec/icecc/bin"
if [ ! -d ${icecc_path} ]; then
    mkdir -p ${icecc_path}
fi

ln -s -f ${icecream_home}/bin/icecc ${icecc_path}/c++
ln -s -f ${icecream_home}/bin/icecc ${icecc_path}/cc
ln -s -f ${icecream_home}/bin/icecc ${icecc_path}/clang
ln -s -f ${icecream_home}/bin/icecc ${icecc_path}/clang++
ln -s -f ${icecream_home}/bin/icecc ${icecc_path}/g++
ln -s -f ${icecream_home}/bin/icecc ${icecc_path}/gcc

cd ${icecc_path}/..
ln -s -f ${icecream_home}/bin/icecc-create-env icecc-create-env

echo "Icecream install successfully"
