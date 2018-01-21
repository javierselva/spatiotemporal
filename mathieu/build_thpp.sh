#!/bin/bash -e
#
#  Copyright (c) 2014, Facebook, Inc.
#  All rights reserved.
#
#  This source code is licensed under the BSD-style license found in the
#  LICENSE file in the root directory of this source tree. An additional grant
#  of patent rights can be found in the PATENTS file in the same directory.
#
#
set -o pipefail

if [[ ! -r ./Tensor.h ]]; then
  echo "Please run from the thpp subdirectory." >&2
  exit 1
fi

### These lines were modified as the original scripts downloads from an outdated link
rm -rf googletest-release-1.7.0 googletest-release-1.7.0.zip
curl -JLO https://github.com/google/googletest/archive/release-1.7.0.zip
mv googletest-release-1.7.0.zip gtest-1.7.0.zip
unzip gtest-1.7.0.zip
mv googletest-release-1.7.0 gtest-1.7.0

# Build in a separate directory
mkdir -p build
cd build

# Configure
cmake ..

# Make
make

# Run tests
ctest

# Install
sudo make install

