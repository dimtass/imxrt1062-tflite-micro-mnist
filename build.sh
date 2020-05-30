#!/bin/bash -e

echo "Building the project in Linux environment"

# Toolchain path
: ${TOOLCHAIN_DIR:="/opt/toolchains/gcc-arm-none-eabi-9-2019-q4-major"}
# select cmake toolchain
: ${CMAKE_TOOLCHAIN:=armgcc.cmake}
# select to clean previous builds
: ${CLEANBUILD:=false}
# select to create eclipse project files
: ${ECLIPSE_IDE:=false}
# Select DSP/NN lib use
: ${USE_CMSIS_NN:="OFF"}
# Select compressed/uncompressed model use
: ${USE_COMP_MODEL:="OFF"}
# Select FSL lib use
: ${USE_FSL_DRIVER:="ON"}
# Enable overclock?
: ${USE_OVERCLOCKING:="OFF"}
# Flash type for targer
: ${USE_FLASH_TYPE:="NOR"}
# Select source folder. Give a false one to trigger an error
: ${SRC:="src"}

# Set default arch to imxrt
ARCHITECTURE=imxrt
# default generator
IDE_GENERATOR="Unix Makefiles"
# Current working directory
WORKING_DIR=$(pwd)
# cmake scripts folder
SCRIPTS_CMAKE="${WORKING_DIR}/source/cmake"
# Compile objects in parallel, the -jN flag in make
PARALLEL=$(nproc)

if [ ! -d "source/${SRC}" ]; then
    echo -e "You need to specify the SRC parameter to point to the source code"
    exit 1
fi

if [ "${ECLIPSE}" == "true" ]; then
	IDE_GENERATOR="Eclipse CDT4 - Unix Makefiles" 
fi

BUILD_ARCH_DIR=${WORKING_DIR}/build-${ARCHITECTURE}

if [ "${ARCHITECTURE}" == "imxrt" ]; then
    CMAKE_FLAGS="${CMAKE_FLAGS} \
                -DTOOLCHAIN_DIR=${TOOLCHAIN_DIR} \
                -DCMAKE_TOOLCHAIN_FILE=${SCRIPTS_CMAKE}/${CMAKE_TOOLCHAIN} \
                -DUSE_FSL_DRIVER=${USE_FSL_DRIVER} \
                -DUSE_CMSIS_NN=${USE_CMSIS_NN} \
                -DUSE_COMP_MODEL=${USE_COMP_MODEL} \
                -DUSE_OVERCLOCKING=${USE_OVERCLOCKING} \
                -DCMAKE_BUILD_TYPE=flexspi_nor_release \
                -DSRC=${SRC} \
                "
else
    >&2 echo "*** Error: Architecture '${ARCHITECTURE}' unknown."
    exit 1
fi

if [ "${CLEANBUILD}" == "true" ]; then
    echo "- removing build directory: ${BUILD_ARCH_DIR}"
    rm -rf ${BUILD_ARCH_DIR}
fi

echo "--- Pre-cmake ---"
echo "architecture      : ${ARCHITECTURE}"
echo "distclean         : ${CLEANBUILD}"
echo "parallel          : ${PARALLEL}"
echo "cmake flags       : ${CMAKE_FLAGS}"
echo "cmake scripts     : ${SCRIPTS_CMAKE}"
echo "IDE generator     : ${IDE_GENERATOR}"
echo "Threads           : ${PARALLEL}"
echo "USE_CMSIS_NN      : ${USE_CMSIS_NN}"
echo "USE_COMP_MODEL    : ${USE_COMP_MODEL}"
echo "USE_OVERCLOCKING  : ${USE_OVERCLOCKING}"
echo "USE_FLASH_TYPE    : ${USE_FLASH_TYPE}"

mkdir -p build-imxrt
cd build-imxrt

# setup cmake
cmake ../source -G"${IDE_GENERATOR}" ${CMAKE_FLAGS}

# build
make -j${PARALLEL} --no-print-directory
