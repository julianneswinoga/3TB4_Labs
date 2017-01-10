#include "main.h"

__IO INTURUPT_DATA Inturupt_Data = {
	.UBPressed = false,
	.DelayCounter = 0
};

CanTxMsg TxMessage;
CanRxMsg RxMessage;
uint8_t TransmitMailbox = 0;

int main(void) {
	Delay_Config(); // Set SysTick timer
	LED_Config(); // Initialize onboard LEDs
	LCD_Config(); // Initialize LCD
	CAN_Config(); // Set up CAN interface

	while (1) {
		LCD_DisplayLines(0, 0, (uint8_t *)"TEST");
	}
}

void sEE_TIMEOUT_UserCallback() {
	while (1)
		;
}
