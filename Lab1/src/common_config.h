#ifndef __COMMON_CONFIG_H
#define __COMMON_CONFIG_H

#include <stdio.h>
#include "stm32f4xx.h"
#include "stm32f429i_discovery.h"

#define ADC3_DR_ADDRESS     ((uint32_t)0x4001224C)

void PB_Config(void);
void LED_Config(void);
void TIM3_Config(uint32_t, uint16_t);
void TIM3_OCConfig(__IO uint16_t);
void TIM3_ChangePeriod(uint32_t);
void RNG_Config(void);
void Delay_Config(void);
void GPIO_Config(void);
void Button_Inturupt_Config(uint8_t, uint8_t, uint32_t, EXTITrigger_TypeDef, IRQn_Type);
void ADC_Config(void);
void PWM_Config(void);
void TIM4_Config(void);

#endif /* __COMMON_CONFIG_H */
