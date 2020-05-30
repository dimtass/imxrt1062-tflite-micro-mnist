#!/bin/bash -e
#
# Example:
#   ./docker-build.sh "USE_CORTEX_NN=ON ./build.sh"

docker run --rm -it -v $(pwd):/tmp/tflite -w=/tmp/tflite dimtass/stm32-cde-image:0.1 -c "${1}"