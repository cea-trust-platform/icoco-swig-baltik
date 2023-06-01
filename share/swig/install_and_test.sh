#!/bin/bash

rm -rf build
rm -rf install

mkdir -p build

. $project_directory/env_for_python.sh

cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install -DSWIG_EXECUTABLE=$TRUST_ROOT/exec/python/bin/swig

make -j install
ctest || exit -1

cd ..

