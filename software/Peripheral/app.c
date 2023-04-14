/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdlib.h>
#include <io.h>
#include <stdio.h>
#include <inttypes.h>
#include <stdbool.h>
#include <unistd.h>

#include "system.h"
#include "peripheral/peripheral.h"

int main() {
	// Hardware control structures
	peripheral_dev peripheral = peripheral_inst((void *) PERIPHERAL_0_BASE);

	printf("Hello from Nios II!\n");
	printf("%d\n", PERIPHERAL_MASK_SECOND);
	printf("%d\n", PERIPHERAL_MASK_THIRD);

	while (true) {
		printf("Current values 1, 2, 3: %d\n", (int)peripheral_read(&peripheral, 0));
		printf("First value in this: %#04x\n", (int)peripheral_read(&peripheral, 0) & PERIPHERAL_MASK_FIRST);
		printf("Second value in this: %#04x\n", (int)(peripheral_read(&peripheral, 0) & PERIPHERAL_MASK_SECOND) >> 6);
		printf("Third value in this: %#04x\n", (int)(peripheral_read(&peripheral, 0) & PERIPHERAL_MASK_THIRD) >> 12);
		printf("Current value 4, 5, 6: %d\n", (int)peripheral_read(&peripheral, 4));
		printf("First value in this: %#04x\n", (int)(peripheral_read(&peripheral, 4) & PERIPHERAL_MASK_FIRST));
		printf("Second value in this: %#04x\n", (int)(peripheral_read(&peripheral, 4) & PERIPHERAL_MASK_SECOND) >> 6);
		printf("Third value in this: %#04x\n", (int)(peripheral_read(&peripheral, 4) & PERIPHERAL_MASK_THIRD) >> 12);
		usleep(5000000);
	}

	return 0;
}
