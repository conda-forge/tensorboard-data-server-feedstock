#!/bin/bash

set -euxo pipefail

pushd tensorboard/data/server
cargo build --release

pushd pip_package

$PYTHON build.py --out-dir="$SRC_DIR/" --server-binary=../target/${CARGO_BUILD_TARGET}/release/rustboard
$PYTHON -m pip install --no-deps --ignore-installed -v $SRC_DIR/*.whl
