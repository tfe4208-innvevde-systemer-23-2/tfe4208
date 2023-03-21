#ifndef __PANTILT_H__
#define __PANTILT_H__

#include "pwm/pwm.h"

/* joysticks device structure */
typedef struct pantilt_dev {
    pwm_dev pwm_v; /* Vertical PWM device handle */
    pwm_dev pwm_h; /* Horizontal PWM device handle */
} pantilt_dev;

/*******************************************************************************
 *  Public API
 ******************************************************************************/

#define PANTILT_PWM_CLOCK_FREQ_HZ       (50000000) // 50.00 MHz

#define PANTILT_PWM_PERIOD_US           (20000)    // 20.00 ms

/* Vertical servo */
#define PANTILT_PWM_V_MIN_DUTY_CYCLE_US (100)      //  0.10 ms
#define PANTILT_PWM_V_MAX_DUTY_CYCLE_US (2250)     //  2.25 ms

/* Horizontal servo */
#define PANTILT_PWM_H_MIN_DUTY_CYCLE_US (100)     //  0.10 ms
#define PANTILT_PWM_H_MAX_DUTY_CYCLE_US (2250)     //  2.25 ms

pantilt_dev pantilt_inst(void *pwm_v_base, void *pwm_h_base);

void pantilt_init(pantilt_dev *dev);

void pantilt_configure_vertical(pantilt_dev *dev, uint32_t duty_cycle);
void pantilt_configure_horizontal(pantilt_dev *dev, uint32_t duty_cycle);
void pantilt_set_angle_vertical(pantilt_dev *dev, uint8_t verticalAngle);
void pantilt_set_angle_horizontal(pantilt_dev *dev, uint8_t horizontalAngle);
void pantilt_set_angles(pantilt_dev *dev, uint8_t verticalAngel, uint8_t horizontalAngle);
uint32_t pantilt_calculate_duty(uint8_t angle);
void pantilt_start_vertical(pantilt_dev *dev);
void pantilt_start_horizontal(pantilt_dev *dev);
void pantilt_stop_vertical(pantilt_dev *dev);
void pantilt_stop_horizontal(pantilt_dev *dev);

#endif /* __PANTILT_H__ */
