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
	// NOTE: No GPIO ports or CAN bus is used for running in the Silent and
	// Loopback mode,
	// but required for normal operation
	// The Baudrate of CAN bus used in lab is 500k Bps
	/* CAN GPIOs configuration
	 * **************************************************/
	/* Enable GPIO clock */
	/* Connect CAN pins to AF9 */
	/* Configure CAN RX and TX pins */
	/* Use GPIO_Init() to initialize GPIO*/
	/* CAN configuration
	 * ********************************************************/
	/* Enable CAN clock */
	RCC_APB1PeriphClockCmd(CAN_CLK, ENABLE);
	/* CAN register init */
	CAN_DeInit(CANx);
	/* CAN cell init */
	// CAN_InitStructure.CAN_TTCM = ?;
	//  CAN_InitStructure.CAN_ABOM = ?;
	//  CAN_InitStructure.CAN_AWUM = ?;
	CAN_InitStructure.CAN_NART = ENABLE;
	//  CAN_InitStructure.CAN_RFLM = ?;
	//  CAN_InitStructure.CAN_TXFP = ?;
	CAN_InitStructure.CAN_Mode =
		CAN_Mode_Silent_LoopBack; // Modify for normal mode
	// CAN_InitStructure.CAN_SJW = ?;
	// CAN Baudrate = 500 Bps
	// The bus the CAN is attached is of 45 Mhz.
	// with prescaler 3 (this is the "real" prescaler, during init process, 2
	// will
	// be written in register) while 1tq=2 clock cycle. (CAN clocked at 45  MHz
	// for F429i board)
	// so the baudrate should be 45/3/2/15   (15 is: 1+ 9forBS1 + 5forBS2)  =0.5
	// M
	// Bps (500 K Bps)
	//  CAN_InitStructure.CAN_BS1 = ?;
	//  CAN_InitStructure.CAN_BS2 = ?;
	//  CAN_InitStructure.CAN_Prescaler = ?;
	CAN_Init(CANx, &CAN_InitStructure);
/* CAN filter init */
#ifdef USE_CAN1
	CAN_FilterInitStructure.CAN_FilterNumber = 0;
#else  /* USE_CAN2 */
	CAN_FilterInitStructure.CAN_FilterNumber = 14;
#endif /* USE_CAN1 */
	CAN_FilterInitStructure.CAN_FilterMode			 = CAN_FilterMode_IdMask;
	CAN_FilterInitStructure.CAN_FilterScale			 = CAN_FilterScale_32bit;
	CAN_FilterInitStructure.CAN_FilterIdHigh		 = 0x0000;
	CAN_FilterInitStructure.CAN_FilterIdLow			 = 0x0000;
	CAN_FilterInitStructure.CAN_FilterMaskIdHigh	 = 0x0000;
	CAN_FilterInitStructure.CAN_FilterMaskIdLow		 = 0x0000;
	CAN_FilterInitStructure.CAN_FilterFIFOAssignment = 0;
	CAN_FilterInitStructure.CAN_FilterActivation	 = ENABLE;
	CAN_FilterInit(&CAN_FilterInitStructure);
	/* Transmit Structure preparation */
	Inturupt_Data.TxMessage.StdId   = GROUP_ID;
	Inturupt_Data.TxMessage.ExtId   = 0x00;
	Inturupt_Data.TxMessage.RTR		= CAN_RTR_DATA;
	Inturupt_Data.TxMessage.IDE		= CAN_ID_STD;
	Inturupt_Data.TxMessage.DLC		= 1;
	Inturupt_Data.TxMessage.Data[0] = (GROUP_ID & 0x0FF); // group id
	/* Enable FIFO 0 message pending Interrupt */
}
