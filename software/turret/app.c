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
#define PANTILT_STEP_US (25)	  //  25  us

int main(void)
{
	// Hardware control structures
	pantilt_dev pantilt = pantilt_inst((void *)PWM_0_BASE, (void *)PWM_1_BASE, (void *)PWM_2_BASE);
	peripheral_dev peripheral = peripheral_inst((void *)PERIPHERAL_0_BASE);

	// Initialize pwm hardware
	pantilt_init(&pantilt);

	// Create lags structure
	peripheral_lags lags;
	// lags = (peripheral_lags *)malloc(sizeof(peripheral_lags));

	// More setup probably
	printf("Init complete, starting up...\n\n");

	// Init angles and matrices
	double **x = dmatrix(1, 3, 1, 1);
	double **delays = dmatrix(1, 6, 1, 1);
	double **u_t = dmatrix(1, 3, 1, 6);
	double **v_t = dmatrix(1, 3, 1, 3);
	double **sigma_inv = dmatrix(1, 3, 1, 3);
	double** temp = dmatrix(1,3,1,3);
    double** temp2 = dmatrix(1,3,1,6);
	double** new_r = dmatrix(1,3,1,1);
	int *angles = malloc(2 * sizeof(int));
	init_angles(u_t, v_t, sigma_inv);

	printf("a");

	// Main flow
	while (true)
	{

		// Read lags
		getLags(&peripheral, &lags);
		uint32_t debug = peripheral_read_debug(&peripheral);

		// Calculate angles
		... get_angles_from_correlation(&lags);

		// Control PWM

		// For debug
		printf("Lags: %d, %d, %d, %d, %d, %d\n", (int)lags.t01, (int)lags.t02, (int)lags.t03, (int)lags.t12, (int)lags.t13, (int)lags.t23);
		printf("vertical: %d, horizontal: %d", angles[0], angles[1]);
		angles[0] = (angles[0] == 0x7fffffff) ? 0 : angles[0];
		printf("debug: %d\n", (int)debug);
		
		usleep(1000000);
	}

	return EXIT_SUCCESS;
}
