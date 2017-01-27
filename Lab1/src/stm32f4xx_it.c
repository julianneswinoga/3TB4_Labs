/*
* Inturupt handler file
*/

#include "stm32f4xx_it.h"
#include "main.h"

extern __IO INTURUPT_DATA Inturupt_Data;

// Unused
void NMI_Handler(void) {}

// Unused
void HardFault_Handler(void) {
	while (1) {}
}

// Unused
void MemManage_Handler(void) {
	while (1) {}
}

// Unused
void BusFault_Handler(void) {
	while (1) {}
}

// Unused
void UsageFault_Handler(void) {
	while (1) {}
}

// Unused
void SVC_Handler(void) {}

// Unused
void DebugMon_Handler(void) {}

// Unused
void PendSV_Handler(void) {}

/*
* Because of Delay_Config(), SysTick now executes every 1ms
*/
void SysTick_Handler(void) {
	if (Inturupt_Data.DelayCounter > 0) Inturupt_Data.DelayCounter--;
}

/*
* TIM3 inturupt
*/
void TIM3_IRQHandler(void) {}

void EXTI0_IRQHandler(void) {}

void CAN1_RX0_IRQHandler(void) {
	Inturupt_Data.CAN_Recieved = true;
	CanRxMsg RxMessage;
	int		 i = 0;
	CAN_Receive(CANx, 0, &RxMessage);
	for (i = 0; i < 8; i++) Inturupt_Data.CAN_RxMessage[i] = RxMessage.Data[i];
}
