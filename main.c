/* Trivial LED blink program for Teensy3x */

#include  "board/teensy3x.h"

int
main(void)
{
	volatile uint32_t n;

	/* Configure PC5 as GPIO (alt = 0x01), and output */
	PORTC_PCR5 = PORT_PCR_MUX(0x1);
	GPIOC_PDDR = 1<<5;
	GPIOC_PCOR = 1<<5; /* LED off */

	while (1) {
		GPIOC_PSOR = 1<<5; /* LED on */
		for (n = mcg_clk_hz / 100; n; n--) ; /* delay */
		GPIOC_PCOR = 1<<5; /* LED off */
		for (n = mcg_clk_hz / 200; n; n--) ; /* delay */
	}
	return 0;
}
