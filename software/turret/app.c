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

    return EXIT_SUCCESS;
}