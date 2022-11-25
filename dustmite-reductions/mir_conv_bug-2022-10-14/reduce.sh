#!/bin/bash

set -eu

# this should be defaulted in dub dustmite
DESTINATION_DIRECTORY="/tmp/dustmite-reductions$(pwd)"

rm -rf "${DESTINATION_DIRECTORY}"

dub dustmite -v "${DESTINATION_DIRECTORY}" \
    --trace \
    --compiler-status=2 \
    --compiler-regex='cannot call impure function' \
    --compiler=dmd
