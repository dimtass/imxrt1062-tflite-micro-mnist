#!/bin/bash -e

echo "Flashing firmware to Teensy 4.0..."
teensy_loader_cli -v -w --mcu=imxrt1062 build-imxrt/flexspi_nor_release/imxrt1062-tflite-micro-mnist.hex