#ifndef __MAIN_H
#define __MAIN_H

#include "LCDUtils.h"
#include "common_config.h"
#include "helpers.h"
#include "stdbool.h"
#include "stm32f429i_discovery.h"
#include "stm32f4xx.h"
#include <stdio.h>

#define GROUP_ID 35
#define TA_ID 0x000

#define KEY_PRESSED 0x00
#define KEY_NOT_PRESSED 0x01

#define USE_CAN1

#ifdef USE_CAN1
#define CANx CAN1
#define CAN_CLK RCC_APB1Periph_CAN1
#define CAN_RX_PIN GPIO_Pin_0
#define CAN_TX_PIN GPIO_Pin_1
#define CAN_GPIO_PORT GPIOD
#define CAN_GPIO_CLK RCC_AHB1Periph_GPIOD
#define CAN_AF_PORT GPIO_AF_CAN1
#define CAN_RX_SOURCE GPIO_PinSource0
#define CAN_TX_SOURCE GPIO_PinSource1
#else /*USE_CAN2*/
#define CANx CAN2
#define CAN_CLK (RCC_APB1Periph_CAN1 | RCC_APB1Periph_CAN2)
#define CAN_RX_PIN GPIO_Pin_12
#define CAN_TX_PIN GPIO_Pin_13
#define CAN_GPIO_PORT GPIOB
#define CAN_GPIO_CLK RCC_AHB1Periph_GPIOB
#define CAN_AF_PORT GPIO_AF_CAN2
#define CAN_RX_SOURCE GPIO_PinSource12
#define CAN_TX_SOURCE GPIO_PinSource13
#endif /* USE_CAN1 */

typedef struct {
	__IO bool UBPressed;		// User button
	__IO uint32_t DelayCounter; // Counter for measuring delayed time
	__IO CanTxMsg TxMessage;	// CAN Tx Message
} INTURUPT_DATA;

#endif /* __MAIN_H */
