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

	// Initialize pwm hardware
	pantilt_init(&pantilt);
	pantilt_configure_vertical(&pantilt, 1500);
	pantilt_configure_horizontal(&pantilt, 1500);
	pantilt_configure_trigger(&pantilt, 1500);
	// pantilt_start_vertical(&pantilt);
	pantilt_start_horizontal(&pantilt);
	// pantilt_start_trigger(&pantilt);

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
	double **temp = dmatrix(1, 3, 1, 3);
	double **temp2 = dmatrix(1, 3, 1, 6);
	double **new_r = dmatrix(1, 3, 1, 1);
	int *angles = malloc(2 * sizeof(int));
	init_angles(u_t, v_t, sigma_inv);

	double angle;
	// double old_angle;

	// Main flow
	while (true)
	{

		// Read lags
		getLags(&peripheral, &lags);
		printf("Lags: %d, %d, %d, %d, %d, %d\n", (int)lags.t01, (int)lags.t02, (int)lags.t03, (int)lags.t12, (int)lags.t13, (int)lags.t23);

		// pantilt_shoot(&pantilt);
		// usleep(2000000);
		// continue;
		
		if (lags.t01 > 11 || lags.t02 > 11 || lags.t12 > 11)
		{
			// printf("No signal\n");
			usleep(100000);
			continue;
		}

		uint32_t debug = peripheral_read_debug(&peripheral);

		// Calculate angles

		// get_angles_from_correlation(lags, angles, x, delays, v_t, u_t, sigma_inv, temp, temp2, new_r);
		angle = calculateAngle(&lags);
		angle = rad2deg(angle);

		// For debug
		printf("vertical: %f\n", angle);
		printf("debug: %d\n", (int)debug);

		// Control turret

		if (angle > 0.1)
		{
			pantilt_start_horizontal(&pantilt);
			pantilt_set_angles(&pantilt, 90, angle);
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
