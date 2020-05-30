/*
 * Copyright (c) 2013 - 2015, Freescale Semiconductor, Inc.
 * Copyright 2016-2017 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <cstdio>
#include "MIMXRT1062.h"
#include "board.h"
#include "fsl_debug_console.h"

#include "pin_mux.h"
#include "clock_config.h"
#include "digit.h"

#if defined(COMP_MODEL)
#include "model_data_compressed.h"
#else
#include "model_data_uncompressed.h"
#endif

#include "tensorflow/lite/micro/kernels/all_ops_resolver.h"
#include "tensorflow/lite/micro/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/version.h"
#include "schema_generated.h"

#include "mnist_schema_generated.h"
/*******************************************************************************
 * Definitions
 ******************************************************************************/
#define CODE_VERSION 100
#define DEMO_LPUART LPUART2
#define DEMO_LPUART_CLK_FREQ BOARD_DebugConsoleSrcFreq()
#define ECHO_BUFFER_LENGTH 8
#define TENSOR_ARENA_SIZE (262144/3)
#define TRACE(X) PRINTF X

/*******************************************************************************
 * Prototypes
 ******************************************************************************/

void ViewModel(struct tflite_model *tf);
void RunInference(struct tflite_model *tf, float *data, size_t data_size, uint8_t debug);
uint32_t disableInts(void);
void restoreInts(uint32_t state);

/*******************************************************************************
 * Variables
 ******************************************************************************/
__IO float glb_inference_time_ms = 0;

struct tflite_model {
    const tflite::Model* model;
    tflite::ErrorReporter* error_reporter;
    tflite::MicroInterpreter* interpreter;
    TfLiteTensor* input;
    TfLiteTensor* output;
    int inference_count;
    uint8_t tensor_arena[TENSOR_ARENA_SIZE];
};
struct tflite_model tf;

/*******************************************************************************
 * Code
 ******************************************************************************/

/*!
 * @brief Main function
 */
int main(void)
{
    BOARD_ConfigMPU();
    BOARD_InitPins();
    BOARD_BootClockRUN();
    BOARD_InitDebugConsole();

    /* Send g_tipString out. */
    TRACE(("Program started: %d\r\n", SystemCoreClock));
    
    // Set up logging
    tflite::MicroErrorReporter micro_error_reporter;
    tf.error_reporter = &micro_error_reporter;

    // Map the model into a usable data structure. This doesn't involve any
    // copying or parsing, it's a very lightweight operation.
    tf.model = tflite::GetModel(jupyter_notebook_mnist_tflite);
    if (tf.model->version() != TFLITE_SCHEMA_VERSION) {
    	TF_LITE_REPORT_ERROR(tf.error_reporter,
                         "Model provided is schema version %d not equal "
                         "to supported version %d.",
                         tf.model->version(), TFLITE_SCHEMA_VERSION);
    }

	// This pulls in all the operation implementations we need.
	// NOLINTNEXTLINE(runtime-global-variables)
	static tflite::ops::micro::AllOpsResolver resolver;

    // Build an interpreter to run the model with
    tf.interpreter = new tflite::MicroInterpreter(tf.model, resolver, tf.tensor_arena, TENSOR_ARENA_SIZE, tf.error_reporter);

	// Allocate memory from the tensor_arena for the model's tensors.
	TfLiteStatus allocate_status = tf.interpreter->AllocateTensors();
	if (allocate_status != kTfLiteOk) {
		TF_LITE_REPORT_ERROR(tf.error_reporter, "AllocateTensors() failed");
	}
    tf.inference_count = 0;

    while (1)
    {
        int ch = GETCHAR();
        if (ch == '1') {
            ViewModel(&tf);
        }
        else if (ch == '2') {
            RunInference(&tf, (float *)digit, 784, 1);
        }
    }
}


uint32_t disableInts(void)
{
    uint32_t state;

    state = __get_PRIMASK();
    __disable_irq();

    return state;
}

void restoreInts(uint32_t state)
{
   __set_PRIMASK(state);
}

void ViewModel(struct tflite_model *tf)
{
    TfLiteTensor *input = tf->interpreter->input(0);
    TfLiteTensor *output = tf->interpreter->output(0);

    TRACE(("Model input:\n"));
    TRACE(("dims->size: %d\n", input->dims->size));
    TRACE(("dims->data[0]: %d\n", input->dims->data[0]));
    TRACE(("dims->data[1]: %d\n", input->dims->data[1]));
    TRACE(("dims->data[2]: %d\n", input->dims->data[2]));
    TRACE(("dims->data[3]: %d\n", input->dims->data[3]));
    TRACE(("input->type: %d\n\n", input->type));

    TRACE(("Model output:\n"));
    TRACE(("dims->size: %d\n", output->dims->size));
    TRACE(("dims->data[0]: %d\n", output->dims->data[0]));
    TRACE(("dims->data[1]: %d\n\n", output->dims->data[1]));
}

void RunInference(struct tflite_model *tf, float *data, size_t data_size, uint8_t debug)
{
    // // Obtain pointers to the model's input and output tensors
    TfLiteTensor *input = tf->interpreter->input(0);
    TfLiteTensor *output = tf->interpreter->output(0);

    /* Copy data to the input buffer. So much wasted RAM! */
    for (size_t i = 0; i < data_size; i++) {
        input->data.f[i] = data[i];
    }

    if (debug) TRACE(("Running inference...\n"));

    uint32_t ints = disableInts();
    glb_inference_time_ms = 0;
    // Run the model on this input and make sure it succeeds.
    TfLiteStatus invoke_status = tf->interpreter->Invoke();
    if (invoke_status != kTfLiteOk) {
        tf->error_reporter->Report("Invoke failed\n");
    }
    restoreInts(ints);

    if (debug) {
        TRACE(("Done in %f msec...\n", glb_inference_time_ms));
        for (size_t i = 0; i < 10; i++) {
            TRACE(("Out[%d]: %f\n", i, output->data.f[i]));
        }
    }
}