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
	double **matrise = create_matrix(3, 6);
	pseudo_inv(matrise);
	double **delays = create_matrix(6, 1);
	double **r = create_matrix(3, 1);

	// Initialize pwm hardware
	pantilt_init(&pantilt);
	pantilt_configure_vertical(&pantilt, 1500);
	pantilt_configure_horizontal(&pantilt, 1500);
	pantilt_shoot_init(&pantilt);

	// Create lags structure
	peripheral_lags lags;

	// Allocate memory for angles
	double *calcAngle = malloc(2 * sizeof(double));

	printf("Init complete, starting up...\n\n");
	printf("====================================\n");

	// Main flow
	while (true)
	{

		// Read lags
		getLags(&peripheral, &lags);
		printf("Lags: %d, %d, %d, %d, %d, %d, Flags: %d\n", (int)lags.t01, (int)lags.t02, (int)lags.t03, (int)lags.t12, (int)lags.t13, (int)lags.t23, lags.flags);

		//  Read debug data
		uint32_t debug = peripheral_read_debug(&peripheral);
		printf("debug: %d\n", (int)debug);

		// Preprocessing of data
		bool inValidCorrelations = lags.t01 == 12 || lags.t02 == 12 || lags.t12 == 12 || lags.t03 == 12 || lags.t13 == 12 || lags.t23 == 12;
		bool inValidCombination = lags.t01 == 0 && lags.t02 == 0 && lags.t12 == 0 && lags.t03 == 0 && lags.t13 == 0 && lags.t23 == 0;

		if (inValidCorrelations || inValidCombination)
		{
			printf("No signal\n");
			usleep(10000);
			continue;
		}

		get_angles_from_correlation(&lags, matrise, delays, r, calcAngle);

		// Calculate angles
		printf("vertical: %f, horizontal: %f \n", calcAngle[0], calcAngle[1]);

		// Adjust angles within the limits
		if (calcAngle[0] < 60)
			calcAngle[0] = 60;
		else if (calcAngle[0] > 140)
			calcAngle[0] = 140;

		if (calcAngle[1] < -90)
			calcAngle[1] = 180;
		else if (calcAngle[1] < 0)
			calcAngle[1] = 0;

		// Control PWM
		if (lags.flags & 0b10)
		{
			pantilt_start_horizontal(&pantilt);
			pantilt_start_vertical(&pantilt);
			pantilt_set_angles(&pantilt, 180 - calcAngle[0], 180 - calcAngle[1]);

			usleep(150000);

			pantilt_stop_horizontal(&pantilt);
			pantilt_stop_vertical(&pantilt);

			usleep(300000);
		}

		// Shoot if we have to
		if ((~lags.flags) & 0b01)
		{
			printf("FIRE!!!");
			pantilt_shoot(&pantilt);
		}
	}

	return EXIT_SUCCESS;
}
