#ifndef __LCDUTILS_H
#define __LCDUTILS_H

#include <stdio.h>
#include <stdlib.h>
#include "stm32f4xx.h"
#include "stm32f429i_discovery.h"
#include "stm32f429i_discovery_lcd.h"

#define COLUMN(x) ((x) * (((sFONT *)LCD_GetFont())->Width))    //see font.h, for defining LINE(X)

void LCD_Config(void);
void LCD_DisplayLines(uint16_t, uint16_t, uint8_t *);
void LCD_DisplayString(uint16_t, uint16_t, uint8_t *);
void LCD_DisplayInt(uint16_t, uint16_t, int);
void LCD_DisplayFloat(uint16_t, uint16_t, float, int);

#endif /* __LCDUTILS_H */
