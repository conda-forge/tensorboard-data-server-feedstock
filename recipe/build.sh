#!/bin/bash

set -euxo pipefail

pushd tensorboard/data/server
cargo build --release

pushd pip_package

if [[ "${target_platform}" == "osx-arm64" ]]; then
  export PLATFORM_FLAGS="--platform macosx_11_0 --cpu arm64"
else
  export PLATFORM_FLAGS=""
fi

$PYTHON build.py --out-dir="$SRC_DIR/" --server-binary=../target/${CARGO_BUILD_TARGET}/release/rustboard $PLATFORM_FLAGS
$PYTHON -m pip install --no-deps --ignore-installed -v $SRC_DIR/*.whl
