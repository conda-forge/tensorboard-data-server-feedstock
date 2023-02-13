#!/bin/bash

set -euxo pipefail

pushd tensorboard/data/server
cargo build --release

pushd pip_package

if [[ "${target_platform}" == "osx-arm64" ]]; then
  $PYTHON build.py --out-dir="$SRC_DIR/" --server-binary=../target/${CARGO_BUILD_TARGET}/release/rustboard --platform macosx_11_0 --cpu arm64
  # WHEEL_NAME=$(ls $SRC_DIR/*.whl)
  # NEW_WHEEL_NAME=${WHEEL_NAME/macosx_10_9_aarch64/macosx_11_0_arm64}
  # mv $WHEEL_NAME ${NEW_WHEEL_NAME}
else
  $PYTHON build.py --out-dir="$SRC_DIR/" --server-binary=../target/${CARGO_BUILD_TARGET}/release/rustboard
fi

$PYTHON -m pip install --no-deps --ignore-installed -v $SRC_DIR/*.whl
