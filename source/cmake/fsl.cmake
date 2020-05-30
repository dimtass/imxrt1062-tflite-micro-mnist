set(FSL_DIR ${CMAKE_SOURCE_DIR}/libs/MIMXRT1062)
set(CMSIS_DIR ${CMAKE_SOURCE_DIR}/libs/cmsis)

# Make sure that git submodule is initialized and updated
if (NOT EXISTS "${FSL_DIR}")
  message(FATAL_ERROR "FSL submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

# Make sure that git submodule is initialized and updated
if (NOT EXISTS "${CMSIS_DIR}")
  message(FATAL_ERROR "cmsis submodule not found. Initialize with 'git submodule update --init' in the source directory")
endif()

include_directories(
    ${FSL_DIR}/../../src/inc
    ${CMSIS_DIR}/Include
    ${FSL_DIR}/drivers
    ${FSL_DIR}/
    ${FSL_DIR}/utilities/str
    ${FSL_DIR}/utilities/debug_console
    ${FSL_DIR}/components/serial_manager
    # ${FSL_DIR}/components/serial_manager/usb_cdc_adapter
    ${FSL_DIR}/components/uart
    ${FSL_DIR}/components/phyksz8081
    ${FSL_DIR}/components/i2c
    ${FSL_DIR}/components/codec/wm8960
    ${FSL_DIR}/components/codec/i2c
    ${FSL_DIR}/components/codec/port
    ${FSL_DIR}/components/codec
    ${FSL_DIR}/components/timer
    ${FSL_DIR}/components/panic
    ${FSL_DIR}/components/led
    ${FSL_DIR}/components/rng
    ${FSL_DIR}/components/fxos8700cq
    ${FSL_DIR}/components/lists
    ${FSL_DIR}/components/common_task
    ${FSL_DIR}/components/spi
    ${FSL_DIR}/components/timer_manager
    ${FSL_DIR}/components/crc
    ${FSL_DIR}/components/button
    ${FSL_DIR}/components/gpio
    ${FSL_DIR}/components/osa
    ${FSL_DIR}/components/mem_manager
    ${FSL_DIR}/components/flash/nand
    ${FSL_DIR}/components/flash/nand/semc
    ${FSL_DIR}/components/flash/nor
    ${FSL_DIR}/components/flash/nor/flexspi
)

set(FSL_LIB_SRC
    ${FSL_DIR}/components/serial_manager/serial_port_uart.c
    # ${FSL_DIR}/components/serial_manager/serial_port_usb_virtual.c
    ${FSL_DIR}/components/serial_manager/serial_manager.c
    # ${FSL_DIR}/components/serial_manager/usb_cdc_adapter/usb_device_cdc_acm.c
    # ${FSL_DIR}/components/serial_manager/usb_cdc_adapter/usb_device_descriptor.c
    # ${FSL_DIR}/components/serial_manager/usb_cdc_adapter/usb_device_ch9.c
    # ${FSL_DIR}/components/serial_manager/usb_cdc_adapter/usb_device_class.c
    # ${FSL_DIR}/components/serial_manager/serial_port_swo.c
    # ${FSL_DIR}/components/serial_manager/serial_port_usb.c
    ${FSL_DIR}/components/uart/lpuart_adapter.c
    ${FSL_DIR}/components/phyksz8081/fsl_phy.c
    ${FSL_DIR}/components/i2c/lpi2c_adapter.c
    ${FSL_DIR}/components/codec/wm8960/fsl_wm8960.c
    ${FSL_DIR}/components/codec/i2c/fsl_codec_i2c.c
    ${FSL_DIR}/components/codec/port/wm8960/fsl_codec_adapter.c
    ${FSL_DIR}/components/codec/fsl_codec_common.c
    ${FSL_DIR}/components/timer/pit_adapter.c
    ${FSL_DIR}/components/timer/gpt_adapter.c
    ${FSL_DIR}/components/panic/panic.c
    ${FSL_DIR}/components/led/led.c
    ${FSL_DIR}/components/rng/trng_adapter.c
    ${FSL_DIR}/components/fxos8700cq/fsl_fxos.c
    ${FSL_DIR}/components/lists/generic_list.c
    ${FSL_DIR}/components/common_task/common_task.c
    ${FSL_DIR}/components/spi/lpspi_adapter.c
    ${FSL_DIR}/components/spi/minispi_adapter.c
    ${FSL_DIR}/components/spi/vspi_adapter.c
    ${FSL_DIR}/components/spi/ecspi_adapter.c
    ${FSL_DIR}/components/timer_manager/timer_manager.c
    ${FSL_DIR}/components/crc/software_crc_adapter.c
    ${FSL_DIR}/components/button/button.c
    ${FSL_DIR}/components/gpio/igpio_adapter.c
    # ${FSL_DIR}/components/osa/fsl_os_abstraction_free_rtos.c
    # ${FSL_DIR}/components/osa/fsl_os_abstraction_bm.c
    ${FSL_DIR}/components/mem_manager/mem_manager.c
    # ${FSL_DIR}/components/video/camera/device/mt9m114/fsl_mt9m114.c
    # ${FSL_DIR}/components/video/camera/device/ov7725/fsl_ov7725.c
    # ${FSL_DIR}/components/video/camera/device/sccb/fsl_sccb.c
    # ${FSL_DIR}/components/video/camera/receiver/csi/fsl_csi_camera_adapter.c
    # ${FSL_DIR}/components/video/i2c/fsl_video_i2c.c
    # ${FSL_DIR}/components/video/fsl_video_common.c
    # ${FSL_DIR}/components/video/display/dc/elcdif/fsl_dc_fb_elcdif.c
    # ${FSL_DIR}/components/flash/nand/semc/fsl_semc_nand_flash.c
    ${FSL_DIR}/components/flash/nor/flexspi/fsl_flexspi_nor_flash.c

    ${FSL_DIR}/system_MIMXRT1062.c
    ${FSL_DIR}/xip/fsl_flexspi_nor_boot.c
    ${FSL_DIR}/xip/evkmimxrt1060_flexspi_nor_config.c
    ${FSL_DIR}/xip/evkmimxrt1060_sdram_ini_dcd.c
    ${FSL_DIR}/utilities/fsl_notifier.c
    ${FSL_DIR}/utilities/str/fsl_str.c
    ${FSL_DIR}/utilities/fsl_assert.c
    ${FSL_DIR}/utilities/fsl_sbrk.c
    ${FSL_DIR}/utilities/debug_console/fsl_debug_console.c
    ${FSL_DIR}/utilities/fsl_shell.c
    # ${FSL_DIR}/cmsis_drivers/fsl_lpspi_cmsis.c
    # ${FSL_DIR}/cmsis_drivers/fsl_lpuart_cmsis.c
    # ${FSL_DIR}/cmsis_drivers/fsl_lpi2c_cmsis.c
    ${FSL_DIR}/drivers/fsl_spdif.c
    ${FSL_DIR}/drivers/fsl_lpspi.c
    ${FSL_DIR}/drivers/fsl_xbara.c
    ${FSL_DIR}/drivers/fsl_flexio_i2c_master.c
    ${FSL_DIR}/drivers/fsl_aoi.c
    ${FSL_DIR}/drivers/fsl_dcp.c
    ${FSL_DIR}/drivers/fsl_tsc.c
    ${FSL_DIR}/drivers/fsl_lpi2c_edma.c
    ${FSL_DIR}/drivers/fsl_dmamux.c
    ${FSL_DIR}/drivers/fsl_flexio_i2s_edma.c
    ${FSL_DIR}/drivers/fsl_flexio_uart.c
    ${FSL_DIR}/drivers/fsl_src.c
    ${FSL_DIR}/drivers/fsl_snvs_lp.c
    ${FSL_DIR}/drivers/fsl_flexspi.c
    ${FSL_DIR}/drivers/fsl_flexio_spi_edma.c
    ${FSL_DIR}/drivers/fsl_flexio_spi.c
    ${FSL_DIR}/drivers/fsl_flexcan.c
    ${FSL_DIR}/drivers/fsl_adc_etc.c
    ${FSL_DIR}/drivers/fsl_lpspi_edma.c
    ${FSL_DIR}/drivers/fsl_kpp.c
    # ${FSL_DIR}/drivers/fsl_lpspi_freertos.c
    ${FSL_DIR}/drivers/fsl_lpi2c.c
    ${FSL_DIR}/drivers/fsl_lpuart.c
    ${FSL_DIR}/drivers/fsl_aipstz.c
    ${FSL_DIR}/drivers/fsl_gpc.c
    # ${FSL_DIR}/drivers/fsl_lpi2c_freertos.c
    ${FSL_DIR}/drivers/fsl_flexio_camera_edma.c
    ${FSL_DIR}/drivers/fsl_flexio_mculcd_edma.c
    ${FSL_DIR}/drivers/fsl_csi.c
    ${FSL_DIR}/drivers/fsl_sai_edma.c
    ${FSL_DIR}/drivers/fsl_dcdc.c
    ${FSL_DIR}/drivers/fsl_qtmr.c
    ${FSL_DIR}/drivers/fsl_common.c
    ${FSL_DIR}/drivers/fsl_clock.c
    ${FSL_DIR}/drivers/fsl_gpio.c
    ${FSL_DIR}/drivers/fsl_adc.c
    ${FSL_DIR}/drivers/fsl_pmu.c
    ${FSL_DIR}/drivers/fsl_pit.c
    ${FSL_DIR}/drivers/fsl_enc.c
    ${FSL_DIR}/drivers/fsl_rtwdog.c
    ${FSL_DIR}/drivers/fsl_usdhc.c
    ${FSL_DIR}/drivers/fsl_ewm.c
    ${FSL_DIR}/drivers/fsl_flexio_mculcd.c
    ${FSL_DIR}/drivers/fsl_flexio_uart_edma.c
    ${FSL_DIR}/drivers/fsl_ocotp.c
    ${FSL_DIR}/drivers/fsl_pxp.c
    ${FSL_DIR}/drivers/fsl_flexio.c
    ${FSL_DIR}/drivers/fsl_gpt.c
    ${FSL_DIR}/drivers/fsl_flexio_i2s.c
    ${FSL_DIR}/drivers/fsl_cmp.c
    ${FSL_DIR}/drivers/fsl_snvs_hp.c
    ${FSL_DIR}/drivers/fsl_lpuart_edma.c
    ${FSL_DIR}/drivers/fsl_trng.c
    ${FSL_DIR}/drivers/fsl_enet.c
    ${FSL_DIR}/drivers/fsl_semc.c
    ${FSL_DIR}/drivers/fsl_spdif_edma.c
    ${FSL_DIR}/drivers/fsl_bee.c
    ${FSL_DIR}/drivers/fsl_elcdif.c
    ${FSL_DIR}/drivers/fsl_flexram.c
    ${FSL_DIR}/drivers/fsl_pwm.c
    # ${FSL_DIR}/drivers/fsl_lpuart_freertos.c
    ${FSL_DIR}/drivers/fsl_edma.c
    ${FSL_DIR}/drivers/fsl_xbarb.c
    ${FSL_DIR}/drivers/fsl_tempmon.c
    ${FSL_DIR}/drivers/fsl_sai.c
    ${FSL_DIR}/drivers/fsl_flexio_camera.c
    ${FSL_DIR}/drivers/fsl_flexcan_edma.c
    ${FSL_DIR}/drivers/fsl_cache.c
    ${FSL_DIR}/drivers/fsl_wdog.c
    ${FSL_DIR}/drivers/fsl_flexram_allocate.c
)

set_source_files_properties(${FSL_LIB_SRC}
    PROPERTIES COMPILE_FLAGS ${ARCH_DEFINES}
)

add_library(fsl STATIC ${FSL_LIB_SRC})

set_target_properties(fsl PROPERTIES LINKER_LANGUAGE C)

# add startup and linker file
set(STARTUP_ASM_FILE "${FSL_DIR}/gcc/startup_MIMXRT1062.S")
# set_property(SOURCE ${STARTUP_ASM_FILE} PROPERTY LANGUAGE ASM)
# set(LINKER_FILE "${FSL_DIR}/gcc/MIMXRT1062xxxxx_flexspi_nor.ld")

set(EXTERNAL_EXECUTABLES ${EXTERNAL_EXECUTABLES} ${STARTUP_ASM_FILE})

set(EXTERNAL_LIBS ${EXTERNAL_LIBS} fsl)