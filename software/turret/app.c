#include <stdlib.h>
#include <io.h>
#include <stdio.h>
#include <inttypes.h>
#include <stdbool.h>
#include <unistd.h>

#include "pantilt/pantilt.h"
#include "peripheral/peripheral.h"
#include "angles/angles.h"
#include "Sanitycheck/Sanity.h"
#include "system.h"

#define SLEEP_DURATION_US (25000) //  25  ms
#define PANTILT_STEP_US (25)	  //  25  us

int main(void)
{
	// Hardware control structures
	pantilt_dev pantilt = pantilt_inst((void *)PWM_0_BASE, (void *)PWM_1_BASE, (void *)PWM_2_BASE);
	peripheral_dev peripheral = peripheral_inst((void *)PERIPHERAL_0_BASE);

	// Set up matrices
    double** matrise = create_matrix(3,6);
    pseudo_inv(matrise);
    double** delays = create_matrix(6,1);
    double** r = create_matrix(3,1);

	// Initialize pwm hardware
	pantilt_init(&pantilt);
	pantilt_configure_vertical(&pantilt, 1500);
	pantilt_configure_horizontal(&pantilt, 1500);
	pantilt_configure_trigger(&pantilt, 1500);
	// pantilt_start_vertical(&pantilt);
	//pantilt_start_horizontal(&pantilt);
	// pantilt_start_trigger(&pantilt);

	// Create lags structure
	peripheral_lags lags;

	// Allocate memory for angles
	double * angle = malloc(2 * sizeof(double));

	// More setup probably
	printf("Init complete, starting up...\n\n");
	printf("====================================\n");
	
	// Main flow
	while (true) {

		// Read lags
		getLags(&peripheral, &lags);
		//printf("Lags: %d, %d, %d, %d, %d, %d\n", (int)lags.t01, (int)lags.t02, (int)lags.t03, (int)lags.t12, (int)lags.t13, (int)lags.t23);

		// Read debug data
		uint32_t debug = peripheral_read_debug(&peripheral);
		printf("debug: %d\n", (int)debug);
		
		// Preprocessing of data
		if (lags.t01 == 12 || lags.t02 == 12 || lags.t12 == 12 || lags.t03 == 12 || lags.t13 == 12 || lags.t23 == 12) {
			// printf("No signal\n");
			usleep(100000);
			continue;
		}

		// Calculate angles
		get_angles_from_correlation(&lags, matrise, delays, r, angle);
		printf("vertical: %f, horizontal: %f \n", angle[0], angle[1]);

		// Control turret
		if (angle[1] > 0.1)
		{
			pantilt_start_horizontal(&pantilt);
			pantilt_set_angles(&pantilt, angle[0], angle[1]);
			usleep(100000);
			pantilt_shoot(&pantilt);
			pantilt_stop_horizontal(&pantilt);
			// usleep(300000);
			
			usleep(300000);

			// old_angle = angle;
		}
		else
		{
			usleep(100000);
		}

		// pantilt_shoot(&pantilt);
		// usleep(2000000);
		// continue;
		// if
		// {
		// 	angle
		// }

		// pantilt_shoot(&pantilt);

		// pantilt_start_horizontal(&pantilt);

		// pantilt_set_angles(&pantilt, 90, 180);
		// printf("180\n");
		// usleep(3000000);

		// // pantilt_set_angles(&pantilt, 90, -89);
		// // printf("-89\n");
		// // usleep(3000000);

		// // pantilt_set_angles(&pantilt, 90, 89);
		// // printf("89\n");
		// // usleep(3000000);

		// pantilt_set_angles(&pantilt, 90, 0);
		// printf("0\n");
		// usleep(3000000);

		// pantilt_stop_horizontal(&pantilt);
	}

	return EXIT_SUCCESS;
}
