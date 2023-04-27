#include <stdlib.h>
#include <io.h>
#include <stdio.h>
#include <inttypes.h>
#include <stdbool.h>
#include <unistd.h>

#include "pantilt/pantilt.h"
#include "peripheral/peripheral.h"
#include "angles/angles.h"
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
   while(true) {

    	// Read lags
    	getLags(&peripheral, &lags);
		uint32_t debug = peripheral_read_debug(&peripheral);
		
        // Calculate angles
		int* angles[2] = malloc(8);
        angles = get_angles_from_correlation(lags);

        // Control PWM

		// For debug
    	printf("Lags: %d, %d, %d, %d, %d, %d\n", (int)lags.t01, (int)lags.t02, (int)lags.t03, (int)lags.t12, (int)lags.t13, (int)lags.t23);
		printf("debug: %d\n", debug);
		usleep(1000000);
	}

    return EXIT_SUCCESS;
}
