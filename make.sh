#!/bin/sh
. ./config.sh
UNAME=`uname`

MAKE_OPT=VERBOSE=1 $@

if [ "$UNAME" = "QNX" ]; then
  CMAKE_OPT=$CMAKE_OPT -DBOOST_ROOT=/usr/pkg
  export CXX=QCC
  export CC=qcc
fi

cmake . ${CMAKE_OPT} | tee build.log

if [ "$UNAME" = "QNX" ]; then
  for F in `find . -name link.txt -or -name relink.txt`;
  do 
    sed -e "s/-export-dynamic/-Wl,-export-dynamic/g " $F > $F.new;
    mv $F.new $F;
  done
fi

make ${MAKE_OPT} | tee -a build.log