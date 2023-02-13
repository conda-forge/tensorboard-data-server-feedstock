#!/bin/bash

set -euxo pipefail

pushd tensorboard/data/server
cargo build --release

pushd pip_package

if [[ "${target_platform}" == "osx-arm64" ]]; then
  $PYTHON build.py --out-dir="$SRC_DIR/" --server-binary=../target/${CARGO_BUILD_TARGET}/release/rustboard --platform macosx_11_0 --cpu arm64
  export SYSTEM_VERSION_COMPAT=1
  $PYTHON -m pip install --no-deps --ignore-installed -v $SRC_DIR/*.whl
else
  $PYTHON build.py --out-dir="$SRC_DIR/" --server-binary=../target/${CARGO_BUILD_TARGET}/release/rustboard
  $PYTHON -m pip install --no-deps --ignore-installed -v $SRC_DIR/*.whl
fi
