#ifndef __MAIN_H
#define __MAIN_H

#include <stdio.h>
#include "stm32f4xx.h"
#include "stm32f429i_discovery.h"
#include "LCDUtils.h"
#include "stdbool.h"

typedef struct {
	__IO bool UBPressed; // User button
	__IO uint32_t DelayCounter; // Counter for measuring delayed time
} INTURUPT_DATA;

#endif /* __MAIN_H */
