/*
* Functions for interacting with the onboard LCD screen.
*/

#include "LCDUtils.h"

/*
* Initialize the LCD
*/
void LCD_Config() {
	LCD_Init(); // LCD initiatization
	LCD_LayerInit(); // LCD Layer initiatization
	LTDC_Cmd(ENABLE); // Enable the LTDC
	LCD_SetLayer(LCD_FOREGROUND_LAYER); // Set LCD foreground layer
	LCD_SetFont(&Font12x12); // Set the font
	LCD_Clear(LCD_COLOR_WHITE); // Clear the screen
}

/*
* Method to catch special characters and enchance LCD screen usability
*/
void LCD_DisplayLines(uint16_t LineNumber, uint16_t ColumnNumber, uint8_t *ptr) {
	uint8_t lines[10][32] = {' '}; // Initialize some chars to store the lines
	int lineCount = 0, charCount = 0; // Variables to store position within the input string

	for (int i = 0; ptr[i] != NULL; i++) { // Loop through the input string
		if (ptr[i] == '\n') { // Check for a newline
			lines[lineCount][charCount] = NULL; // End the output string
			lineCount++; // Advance down a line
			charCount = 0;

		} else {
			lines[lineCount][charCount] = ptr[i]; // Copy over the input character to the current output line
			charCount++;
		}
	}

	for (int i = 0; i <= lineCount; i++) // Loop through the lines
		LCD_DisplayString(LineNumber + i, ColumnNumber, (uint8_t *)lines[i]); // Display the lines one after another
}

/*
* Display a string to the LCD.
*/
void LCD_DisplayString(uint16_t LineNumber, uint16_t ColumnNumber, uint8_t *ptr) {
	while (*ptr != NULL) { // Loop through the input string
		LCD_DisplayChar(LINE(LineNumber), COLUMN(ColumnNumber), *ptr); // Write a character to the screen
		ColumnNumber++;

		if (ColumnNumber * (((sFONT *)LCD_GetFont())->Width) >= LCD_PIXEL_WIDTH ) { // To avoid wrapping on the same line and replacing chars
			ColumnNumber = 0;
			LineNumber++;
		}

		ptr++;
	}
}

/*
* Display an integer to the screen
*/
void LCD_DisplayInt(uint16_t LineNumber, uint16_t ColumnNumber, int Number) {
	char lcd_buffer[15];
	sprintf(lcd_buffer, "%d", Number);
	LCD_DisplayString(LineNumber, ColumnNumber, (uint8_t *) lcd_buffer); // Display the string to the screen
}

/*
* Display a float to the screen
*/
void LCD_DisplayFloat(uint16_t LineNumber, uint16_t ColumnNumber, float Number, int DigitAfterDecimalPoint) {
	char lcd_buffer[15];
	sprintf(lcd_buffer, "%.*f", DigitAfterDecimalPoint, Number); // 6 digits after decimal point, this is also the default setting for Keil uVision 4.74 environment.
	LCD_DisplayString(LineNumber, ColumnNumber, (uint8_t *) lcd_buffer); // Display the string to the screen
}
