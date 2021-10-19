#!/bin/bash

set -euxo pipefail

pushd tensorboard/data/server
cargo tree --no-dedupe
cargo build --release

pushd pip_package
$PYTHON build.py --out-dir="$SRC_DIR/" --server-binary=../target/${CARGO_BUILD_TARGET}/release/rustboard

if [[ "${target_platform}" == "osx-arm64" ]]; then
  WHEEL_NAME=$(ls $SRC_DIR/*.whl)
  NEW_WHEEL_NAME=${WHEEL_NAME/macosx_10_9_x86_64/macosx_11_0_arm64}
  mv $WHEEL_NAME ${NEW_WHEEL_NAME}
fi

$PYTHON -m pip install --no-deps --ignore-installed -v $SRC_DIR/*.whl
