#include <stdlib.h>
#include <io.h>
#include <stdio.h>
#include <inttypes.h>
#include <stdbool.h>
#include <unistd.h>

#include "pantilt/pantilt.h"
#include "peripheral/peripheral.h"
#include "system.h"

#define SLEEP_DURATION_US (25000) //  25  ms
#define PANTILT_STEP_US   (25)    //  25  us

int main(void) {
    // Hardware control structures
    pantilt_dev pantilt = pantilt_inst((void *) PWM_0_BASE, (void *) PWM_1_BASE, (void *) PWM_2_BASE);
	peripheral_dev peripheral = peripheral_inst((void *) PERIPHERAL_0_BASE);

    // Initialize pwm hardware
    pantilt_init(&pantilt);

    // Create lags structure
    peripheral_lags lags;
    //lags = (peripheral_lags *)malloc(sizeof(peripheral_lags));

    // More setup probably
    printf("Init complete, starting up...\n\n");


    // Main flow
   /* while(true) {

    	// Read lags
    	getLags(&peripheral, &lags);
    	// Calculate angles
    	// Control PWM

    	// For debug
    	printf("Lags: %d, %d, %d, %d, %d, %d\n", (int)lags.l01, (int)lags.l02, (int)lags.l03, (int)lags.l12, (int)lags.l13, (int)lags.l23);
    	usleep(1000000);

    }*/

	while (true) {
		//printf("Current values 1, 2, 3: %d\n", (int)peripheral_read(&peripheral, 0));
		printf("%d ", (int)peripheral_read(&peripheral, 0) & PERIPHERAL_MASK_FIRST);
		printf("%d ", (int)(peripheral_read(&peripheral, 0) & PERIPHERAL_MASK_SECOND) >> 6);
		printf("%d ", (int)(peripheral_read(&peripheral, 0) & PERIPHERAL_MASK_THIRD) >> 12);
		//printf("Current value 4, 5, 6: %d\n", (int)peripheral_read(&peripheral, 4));
		printf("%d ", (int)(peripheral_read(&peripheral, 4) & PERIPHERAL_MASK_FIRST));
		printf("%d ", (int)(peripheral_read(&peripheral, 4) & PERIPHERAL_MASK_SECOND) >> 6);
		printf("%d \n", (int)(peripheral_read(&peripheral, 4) & PERIPHERAL_MASK_THIRD) >> 12);
		usleep(1000000);
	}

    return EXIT_SUCCESS;
}
