#include "main.h"

__IO INTURUPT_DATA Inturupt_Data = {.UBPressed = false, .DelayCounter = 0};

CanTxMsg TxMessage;
CanRxMsg RxMessage;
uint8_t  TransmitMailbox = 0;
char     msg[255];

int main(void) {
  Delay_Config(); // Set SysTick timer
  LED_Config();   // Initialize onboard LEDs
  LCD_Config();   // Initialize LCD
  CAN_Config();   // Set up CAN interface
  PB_Config();    // Set up user button
  NVIC_SetPriority(SysTick_IRQn, 0);
  STM_EVAL_LEDOn(LED3); // LED on after reset button pushed

  while (1) {
    while (STM_EVAL_PBGetState(BUTTON_USER) !=
	   KEY_PRESSED) { // If user button pressed
      TransmitMailbox = CAN_Transmit(CANx, &TxMessage); // Transmit message
      STM_EVAL_LEDOff(LED3); // LED off indicates message sent
      sprintf(msg, "DataTx: %i", TxMessage.Data[0]);
      LCD_DisplayLines(1, 1,
		       (uint8_t *)msg); // Display the transmitted message data
      Delay(100);

      if (CAN_TransmitStatus(CANx, TransmitMailbox) ==
	  CANTXOK) { // that is: CAN_TxStatus_Ok, defined value as 0x01
      } else { // if Tx status is CANTXFAILED (0x00), or CDANTXPENDING(0x02), or
	       // CAN_NO_MB(CAN_TxStatus_NoMailBox, 0x04))
	CAN_CancelTransmit(
	    CANx, TransmitMailbox); // Cancel transmit, release transmit mailbox
	// NVIC_SystemReset();		//software reset the board in case LCD
	// has been used.
      }

      Delay(1500);

      if (CAN_GetFlagStatus(CANx, CAN_FLAG_FMP0) !=
	  RESET) {				  // Message pending in FIFO0
	CAN_Receive(CAN1, CAN_FIFO0, &RxMessage); // Receive the message
	STM_EVAL_LEDOn(LED4); // LED on indicates message received
	sprintf(msg, "DataRx: %i", RxMessage.Data[0]);
	LCD_DisplayLines(5, 1, (uint8_t *)msg); // Display data received
	CAN_ClearFlag(CANx, CAN_FLAG_FMP0);     // Clear the flag
      }
    }
  }
}

// I2C error callback
/*void sEE_TIMEOUT_UserCallback() {
	while (1)
		;
}*/