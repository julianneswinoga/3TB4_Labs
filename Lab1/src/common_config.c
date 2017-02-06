/*
* File to store common configuration functions
*/

#include "common_config.h"
#include "main.h"

extern __IO INTURUPT_DATA Inturupt_Data;

void PB_Config(void) {
	STM_EVAL_PBInit(BUTTON_USER, BUTTON_MODE_GPIO);
}

/*
* Initialize the onboard LEDs
*/
void LED_Config(void) {
	STM_EVAL_LEDInit(LED3);
	STM_EVAL_LEDInit(LED4);
}

/*
* Initialize TIM3
*/
void TIM3_Config(uint32_t PERIOD, uint16_t PRESCALER) {
	TIM_TimeBaseInitTypeDef TIM_TimeBaseStructure;
	NVIC_InitTypeDef		NVIC_InitStructure;
	// since TIMER 3 is on APB1 bus, need to enale APB1 bus clock first
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM3, ENABLE);
	// Enable TIM3 global interrupt
	NVIC_InitStructure.NVIC_IRQChannel					 = TIM3_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x00;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority		 = 0x01;
	NVIC_InitStructure.NVIC_IRQChannelCmd				 = ENABLE;
	NVIC_Init(&NVIC_InitStructure);
	TIM_TimeBaseStructure.TIM_Period		= PERIOD;
	TIM_TimeBaseStructure.TIM_Prescaler		= PRESCALER;
	TIM_TimeBaseStructure.TIM_ClockDivision = 0;
	TIM_TimeBaseStructure.TIM_CounterMode   = TIM_CounterMode_Up;
	TIM_TimeBaseInit(TIM3, &TIM_TimeBaseStructure);
}

/*
* Configure the output compare for TIM3
*/
void TIM3_OCConfig(__IO uint16_t PULSE) {
	TIM_OCInitTypeDef TIM_OCInitStructure;
	TIM_OCInitStructure.TIM_OCMode		= TIM_OCMode_Timing;
	TIM_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
	TIM_OCInitStructure.TIM_Pulse		= PULSE;
	TIM_OCInitStructure.TIM_OCPolarity  = TIM_OCPolarity_High;
	TIM_OC1Init(TIM3, &TIM_OCInitStructure);
	TIM_OC1PreloadConfig(TIM3, TIM_OCPreload_Disable);
}

void TIM3_ChangePeriod(uint32_t PERIOD) {
	TIM_TimeBaseInitTypeDef TIM_TimeBaseStructure;
	TIM_TimeBaseStructure.TIM_Period = PERIOD;
	TIM_TimeBaseInit(TIM3, &TIM_TimeBaseStructure);
	TIM_Cmd(TIM3, ENABLE); // Start TIM3
}

/*
* Set up the Systick to be used as a delay inturupt
*/
void Delay_Config(void) {
	SysTick_Config(SystemCoreClock / 1000); // Inturupts in SysTick every 1ms
}

void GPIO_Config(void) {
	GPIO_InitTypeDef GPIO_InitStructure;
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);
	GPIO_InitStructure.GPIO_Pin =
		GPIO_Pin_12 | GPIO_Pin_13 | GPIO_Pin_14 |
		GPIO_Pin_15; // OUT1 (A-), OUT2 (B-), OUT0 (A+), OUT3 (B+)
	GPIO_InitStructure.GPIO_Mode  = GPIO_Mode_OUT;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd  = GPIO_PuPd_DOWN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOD, &GPIO_InitStructure);
	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOE, ENABLE);
	GPIO_InitStructure.GPIO_Pin   = GPIO_Pin_2 | GPIO_Pin_3 | GPIO_Pin_4;
	GPIO_InitStructure.GPIO_Mode  = GPIO_Mode_IN;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_OD;
	GPIO_InitStructure.GPIO_PuPd  = GPIO_PuPd_UP;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	GPIO_Init(GPIOE, &GPIO_InitStructure);
}

/*This function is is used to
configure GPIO ports including enabling of clock
Initializing the CAN, initializing the CAN filters, enabling the FIFO pending
interrupt
*/
void CAN_Config(void) {
	CAN_InitTypeDef		  CAN_InitStructure;
	CAN_FilterInitTypeDef CAN_FilterInitStructure;
	GPIO_InitTypeDef	  GPIO_InitStructure;
	NVIC_InitTypeDef	  NVIC_InitStructure;

	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);

	/* Connect CAN pins to AF9 */
	GPIO_PinAFConfig(GPIOD, GPIO_PinSource0, GPIO_AF_CAN1);
	GPIO_PinAFConfig(GPIOD, GPIO_PinSource1, GPIO_AF_CAN1);

	/* Configure CAN RX and TX pins */
	GPIO_InitStructure.GPIO_Pin   = GPIO_Pin_1 | GPIO_Pin_0;
	GPIO_InitStructure.GPIO_Mode  = GPIO_Mode_AF;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStructure.GPIO_PuPd  = GPIO_PuPd_UP;
	GPIO_Init(GPIOD, &GPIO_InitStructure);

	/* Enable CAN clock */
	RCC_APB1PeriphClockCmd(CAN_CLK, ENABLE);
	/* CAN register init */
	CAN_DeInit(CANx);
	CAN_InitStructure.CAN_TTCM = DISABLE;

	/* Initialize the automatic bus-off management */
	CAN_InitStructure.CAN_ABOM = DISABLE;

	/* Initialize the automatic wake-up mode */
	CAN_InitStructure.CAN_AWUM = ENABLE;

	/* Initialize the no automatic retransmission */
	CAN_InitStructure.CAN_NART = DISABLE;

	/* Initialize the receive FIFO locked mode */
	CAN_InitStructure.CAN_RFLM = DISABLE;

	/* Initialize the transmit FIFO priority */
	CAN_InitStructure.CAN_TXFP = DISABLE;

	/* Initialize the CAN_Mode member */
	CAN_InitStructure.CAN_Mode		= CAN_Mode_Normal;
	CAN_InitStructure.CAN_BS1		= CAN_BS1_9tq;
	CAN_InitStructure.CAN_BS2		= CAN_BS2_5tq;
	CAN_InitStructure.CAN_Prescaler = 3;
	CAN_Init(CANx, &CAN_InitStructure);
/* CAN filter init */
#ifdef USE_CAN1
	CAN_FilterInitStructure.CAN_FilterNumber = 0;
#else  /* USE_CAN2 */
	CAN_FilterInitStructure.CAN_FilterNumber = 14;
#endif /* USE_CAN1 */
	CAN_FilterInitStructure.CAN_FilterMode			 = CAN_FilterMode_IdMask;
	CAN_FilterInitStructure.CAN_FilterScale			 = CAN_FilterScale_16bit;
	CAN_FilterInitStructure.CAN_FilterIdHigh		 = 0x0000;
	CAN_FilterInitStructure.CAN_FilterIdLow			 = 0x0000;
	CAN_FilterInitStructure.CAN_FilterMaskIdHigh	 = 0x0000;
	CAN_FilterInitStructure.CAN_FilterMaskIdLow		 = 0x0000;
	CAN_FilterInitStructure.CAN_FilterFIFOAssignment = CAN_Filter_FIFO0;
	CAN_FilterInitStructure.CAN_FilterActivation	 = ENABLE;
	CAN_FilterInit(&CAN_FilterInitStructure);
	/* Enable FIFO 0 message pending Interrupt */

	/*CAN_ITConfig(CANx, CAN_IT_FMP0,
				 ENABLE); // The FIFO0 message to register interrupt enable

	NVIC_InitStructure.NVIC_IRQChannel = CAN1_RX0_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority =
		1;											   // The main priority 1
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0; // Time priority 0
	NVIC_InitStructure.NVIC_IRQChannelCmd		  = ENABLE;
	NVIC_Init(&NVIC_InitStructure);*/
}
