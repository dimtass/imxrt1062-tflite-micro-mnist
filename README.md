MNIST inference on i.MT RT1062 (Teensy 4.0) using TensorFlow Lite for Microcontrollers
----

[![dimtass](https://circleci.com/gh/dimtass/imxrt1062-tflite-micro-mnist.svg?style=svg)](https://circleci.com/gh/dimtass/imxrt1062-tflite-micro-mnist)

> Note: This project derived from this blog post [here](https://www.stupid-projects.com/tensorflow-2-1-0-for-microcontrollers-benchmarks-on-teensy-4-0/)/

This code can be run on the Teensy 4.0 board and test the MNIST TensorFlow Lite model
I'm using for evaluation and testing purposes in my `Machine Learning for Embedded`
post series which starts from [here](https://www.stupid-projects.com/machine-learning-on-embedded-part-1/).
The most relevant post is [this one](https://www.stupid-projects.com/tensorflow-2-1-0-for-microcontrollers-benchmarks-on-stm32f746/)
as it's the same code running on the STM32F746.

## Usage
First you need to build and upload the project on the stm32f7.
To do that follow the instructions in the build section. After
that you can use the jupyter notebook to hand-draw a digit and
then upload the digit on the stm32f7 and get the prediction back.
Please follow the guide inside the notebook.

In order to run the notebook, you need python3, tensorflow and
PySerial. I've used Ubuntu 18.04 and miniconda, but conda is not
really needed. In any case it's good to run the following commads
on a virtual environment.

Example for conda
```sh
conda create -n nn-env python
conda activate nn-env
conda install -c conda-forge numpy
conda install -c conda-forge jupyter
conda install -c conda-forge tensorflow-gpu
jupyter notebook
```

And then browse to the `jupyter_notebook/MNIST-TensorFlow.ipynb` and run/use the notebook.

> Note: Personally for Jupyter notebooks I'm using the `nvcr.io/nvidia/tensorflow:20.03-tf2-py3`
docker image which can be found [here](https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow).

## Serial ports
The code implements a debug port that you can use to run commands from the terminal.
This is the pinout for Teensy 4.0

UART | Tx | Rx
-|-|-
UART2 | 14 | 15

## Cloning the code
To fetch the repo use either of those two commands:

```sh
git clone git@bitbucket.org:dimtass/imxrt1062-tflite-micro-mnist.git

# or for http
git clone https://dimtass@bitbucket.org/dimtass/imxrt1062-tflite-micro-mnist.git
```

## Build the code
There are a few options that you can use to build the code. To build the code you need
CMAKE and GCC toolchain installed to you system, but you can also use docker to build
the code if you want to skip installing stuff to your host. If you already have CMAKE
then in the `build.sh` file you need to set the path of your toolchain in `TOOLCHAIN_DIR`.
Then to build the code using the default settings run this command:

```sh
./build.sh
```

The available options are:
* `CLEANBUILD`: set to `true` to delete the build folder and re-built. Default value is `false`
which means faster builds when you do changes in the code.
* `USE_CMSIS_NN`: This flag selects which kernels are used in the TF-Lite micro. Default value
is `OFF` which means that the default kernels are used. If it's enabled (set to `ON`) then the
cmsis-nn kernels in `source/libs/tensorflow/tensorflow/lite/micro/kernels/cmsis-nn` are used.
* `USE_COMP_MODEL`: This option selects which model is used. Default value is `OFF` which means
that the uncompressed model is used (float16_t model and weights). If you set it to `ON` then
it uses a model with compressed weights.

## Build with docker
If you want to have the same build environment like the one I've used,
then you can use my CDE image for STM32 (don't mind that) and docker like this:

```sh
./docker-build.sh "USE_COMP_MODEL=ON USE_CMSIS_NN=OFF ./build.sh"
```

#### Examples
```sh
CLEANBUILD=true USE_COMP_MODEL=ON USE_CMSIS_NN=OFF ./build.sh
CLEANBUILD=true USE_COMP_MODEL=OFF USE_CMSIS_NN=ON ./build.sh
```

## Flash
The easiest way to flash the firmware is to use the `teensy_loader_cli` tool from the console.
To do that you need to `cd` to the repo directory then run one of the build commands and if
it's successful then use this command to flash the firmware:

```sh
teensy_loader_cli -v -w --mcu=imxrt1062 build-imxrt/flexspi_nor_release/imxrt1062-tflite-micro-mnist.hex
```

Then you should see this message:
```
Teensy Loader, Command Line, Version 2.1
Read "build-imxrt/flexspi_nor_release/imxrt1062-tflite-micro-mnist.hex": 367472 bytes, 18.1% usage
Waiting for Teensy device...
 (hint: press the reset button)
```

Then you need to press the reset button on the Teensy 4.0 board and the flashing will start:
```
Found HalfKay Bootloader
Read "build-imxrt/flexspi_nor_release/imxrt1062-tflite-micro-mnist.hex": 367472 bytes, 18.1% usage
Programming.........................................................................................................................................................................................................................................................................................................................................................................
Booting
```

> The above example is when the FW is built with this command:
```sh
CLEANBUILD=true USE_COMP_MODEL=ON USE_CMSIS_NN=OFF ./build.sh
```

## UART commands
There are two commands supported using the UART port. You can connect a USB-to-UART
to Teensy using this pinout:

USB-to-UART | Teensy 4.0
-|-
Tx | 14
Rx | 15
GND | G

Then you can use a terminal (I'm using `CuteCom`) and just send one of these commands, folowed
by a `\n` or `\r\n` if you like, but it's not really needed:
* `1`: Executes the `ViewModel()` function that displays information about the model. This is
a sample output:
```
Model input:
dims->size: 4
dims->data[0]: 1
dims->data[1]: 28
dims->data[2]: 28
dims->data[3]: 1
input->type: 1

Model output:
dims->size: 2
dims->data[0]: 1
dims->data[1]: 10
```

* `2`: Runs the model inference. This is a sample output:
```
Running inference...
DEPTHWISE_CONV_2D: 6.283290 msec
MAX_POOL_2D: 0.829997 msec
CONV_2D: 165.644699 msec
MAX_POOL_2D: 0.246270 msec
CONV_2D: 25.556931 msec
FULLY_CONNECTED: 0.781590 msec
FULLY_CONNECTED: 0.098000 msec
SOFTMAX: 0.021400 msec
Done in 199.462173 msec...
Out[0]: 0
Out[1]: 0
Out[2]: 0
Out[3]: 0
Out[4]: 0
Out[5]: 0
Out[6]: 0
Out[7]: 0
Out[8]: 1.000000
Out[9]: 0
```

## Libaries versions
* `CMSIS version`: 5.0.4
* `CMSIS-NN version`: V.2.0.0
* `CMSIS-DSP version`: V1.7.0
* `NXP SDK version`: 1.2

## License
My code's license is MIT and you can use the code however you like. Used libraries may have other licenses!

## Author
Dimitris Tassopoulos <dimtass@gmail.com>