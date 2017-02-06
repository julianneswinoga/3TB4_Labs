#include "main.h"

__IO INTURUPT_DATA Inturupt_Data = {.UBPressed		 = false,
									.DelayCounter	= 0,
									.TransmitMailbox = 0,
									.CAN_Recieved	= false};

char	msg[255];
uint8_t CAN_buf[8];

int main(void) {
	Delay_Config(); // Set SysTick timer
	LED_Config();   // Initialize onboard LEDs
	CAN_Config();   // Set up CAN interface
	PB_Config();	// Set up user button
	NVIC_SetPriority(SysTick_IRQn, 0);
	NVIC_SetPriority(CAN1_RX0_IRQn, 0x1);
	STM_EVAL_LEDOn(LED3); // LED on after reset button pushed
	STM_EVAL_LEDOff(LED4);

	while (1) {
		while (STM_EVAL_PBGetState(BUTTON_USER) !=
			   KEY_PRESSED) { // If user button pressed
			STM_EVAL_LEDOff(LED3); // LED off indicates message sent
			//CAN_buf[0] = GROUP_ID;
			//Can_Send_Msg(CAN_buf, 1);
			
			CanTxMsg TxMessage;
			TxMessage.StdId = 0x0;
			TxMessage.ExtId = 0x0;
			TxMessage.IDE = CAN_ID_STD;
			TxMessage.DLC = 1;
			for (int j = 0;j < 8;j++)
				TxMessage.Data[j] = 0x0;
			TxMessage.Data[0] = GROUP_ID & 0x0FF;
			
			Inturupt_Data.TransmitMailbox = CAN_Transmit(CANx, &TxMessage);

			//sprintf(msg, "DataTx: %i", CAN_buf[0]);
			/*LCD_DisplayLines(
				1, 1,
				(uint8_t *)msg); // Display the transmitted message data
			*/
			Delay(1000);
			
			Can_Receive_Msg(msg);
			LCD_Config(); // Initialize LCD
			sprintf(msg, "DataRx: %i", Msg);
			LCD_DisplayLines(5, 5, msg);

			/*if (CAN_TransmitStatus(CANx, Inturupt_Data.TransmitMailbox) ==
				CANTXOK) { // that is: CAN_TxStatus_Ok, defined value as 0x01
				// LCD_DisplayLines(10, 1, (uint8_t *)"Message sent OK");
				STM_EVAL_LEDOn(LED3);
			} else if (CAN_TransmitStatus(CANx, Inturupt_Data.TransmitMailbox) ==
					   0x02) { // if Tx status is CANTXFAILED (0x00), or
				// CDANTXPENDING(0x02), or
				// CAN_NO_MB(CAN_TxStatus_NoMailBox, 0x04))
				CAN_CancelTransmit(
					CANx, Inturupt_Data.TransmitMailbox); // Cancel transmit,
				STM_EVAL_LEDOn(LED4);
				// LCD_DisplayLines(10, 1, (uint8_t *)"Message cancled!");
			}*/
		}
		if (Inturupt_Data.CAN_RxMessage[0] == GROUP_ID ||
			Inturupt_Data.CAN_Recieved) {
			STM_EVAL_LEDOn(LED3);
			LCD_Config(); // Initialize LCD
			sprintf(msg, "DataTx: %i", Inturupt_Data.CAN_RxMessage[1]);
			LCD_DisplayLines(5, 5, msg);
			Delay(4000);
			NVIC_SystemReset();
		}
	}
}
