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
		printf("Current values 1, 2, 3: %d\n", peripheral_read(&peripheral, 0));
		printf("Second value in this: %d\n", peripheral_read(&peripheral, 0) & PERIPHERAL_MASK_SECOND);
		printf("Current value 4, 5, 6: %d\n", peripheral_read(&peripheral, 0));
		printf("Third value in this: %d\n\n", peripheral_read(&peripheral, 0) & PERIPHERAL_MASK_THIRD);
		usleep(5000000);
	}

	return 0;
}
