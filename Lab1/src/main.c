#include "main.h"

CAN_InitTypeDef        CAN_InitStructure;
CAN_FilterInitTypeDef  CAN_FilterInitStructure;
CanTxMsg TxMessage;
CanRxMsg RxMessage;
uint8_t TransmitMailbox=0; 

int main(void) {
	LCD_Config(); // Initialize LCD

	while(1) {
		LCD_DisplayLines(0, 0, (uint8_t *)"TEST");
	}
	
}

void sEE_TIMEOUT_UserCallback() {
	while (1)
		;
}
