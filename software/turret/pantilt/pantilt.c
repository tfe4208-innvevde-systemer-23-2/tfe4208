#include "pantilt.h"

/**
 * pantilt_inst
 *
 * Instantiate a pantilt device structure.
 *
 * @param pwm_v_base Base address of the vertical PWM component.
 * @param pwm_h_base Base address of the horizontal PWM component.
 */
pantilt_dev pantilt_inst(void *pwm_v_base, void *pwm_h_base, void *pwm_t_base)
{
    pantilt_dev dev;
    dev.pwm_v = pwm_inst(pwm_v_base);
    dev.pwm_h = pwm_inst(pwm_h_base);
    dev.pwm_t = pwm_inst(pwm_t_base);

    return dev;
}

/**
 * pantilt_init
 *
 * Initializes the pantilt device.
 *
 * @param dev pantilt device structure.
 */
void pantilt_init(pantilt_dev *dev)
{
    pwm_init(&(dev->pwm_v));
    pwm_init(&(dev->pwm_h));
    pwm_init(&(dev->pwm_t));
}

/**
 * pantilt_configure_vertical
 *
 * Configure the vertical PWM component.
 *
 * @param dev pantilt device structure.
 * @param duty_cycle pwm duty cycle in us.
 */
void pantilt_configure_vertical(pantilt_dev *dev, uint32_t duty_cycle)
{
    // Need to compensate for inverted servo rotation.
    duty_cycle = PANTILT_PWM_V_MAX_DUTY_CYCLE_US - duty_cycle + PANTILT_PWM_V_MIN_DUTY_CYCLE_US;

    pwm_configure(&(dev->pwm_v),
                  duty_cycle,
                  PANTILT_PWM_PERIOD_US,
                  PANTILT_PWM_CLOCK_FREQ_HZ);
}

/**
 * pantilt_configure_horizontal
 *
 * Configure the horizontal PWM component.
 *
 * @param dev pantilt device structure.
 * @param duty_cycle pwm duty cycle in us.
 */
void pantilt_configure_horizontal(pantilt_dev *dev, uint32_t duty_cycle)
{
    // Need to compensate for inverted servo rotation.
    duty_cycle = PANTILT_PWM_H_MAX_DUTY_CYCLE_US - duty_cycle + PANTILT_PWM_H_MIN_DUTY_CYCLE_US;

    pwm_configure(&(dev->pwm_h),
                  duty_cycle,
                  PANTILT_PWM_PERIOD_US,
                  PANTILT_PWM_CLOCK_FREQ_HZ);
}

/**
 * pantilt_configure_trigger
 *
 * Configure the trigger PWM component.
 *
 * @param dev pantilt device structure.
 * @param duty_cycle pwm duty cycle in us.
 */
void pantilt_configure_trigger(pantilt_dev *dev, uint32_t duty_cycle)
{
    // Need to compensate for inverted servo rotation.
    duty_cycle = PANTILT_PWM_T_MAX_DUTY_CYCLE_US - duty_cycle + PANTILT_PWM_T_MIN_DUTY_CYCLE_US;

    pwm_configure(&(dev->pwm_h),
                  duty_cycle,
                  PANTILT_PWM_PERIOD_US,
                  PANTILT_PWM_CLOCK_FREQ_HZ);
}

/**
 * pantilt_set_angle_vertical
 *
 * Set the horizontal angle.
 *
 * @param dev pantilt device structure.
 * @param verticalAngle in degrees [0-180].
 */
void pantilt_set_angle_vertical(pantilt_dev *dev, uint8_t verticalAngle)
{
    uint32_t duty_cycle = pantilt_calculate_duty(verticalAngle);
    pantilt_configure_vertical(dev, duty_cycle);
}

/**
 * pantilt_set_angle_horizontal
 *
 * Set the horizontal angle.
 *
 * @param dev pantilt device structure.
 * @param horizontalAngle in degrees [0-180].
 */
void pantilt_set_angle_horizontal(pantilt_dev *dev, uint8_t horizontalAngle)
{
    uint32_t duty_cycle = pantilt_calculate_duty(horizontalAngle);
    pantilt_configure_horizontal(dev, duty_cycle);
}

/**
 * pantilt_set_angles
 *
 * Set both the angles.
 *
 * @param dev pantilt device structure.
 * @param verticalAngel in degrees [0-180].
 * @param horizontalAngle in degrees [0-180].
 */
void pantilt_set_angles(pantilt_dev *dev, uint8_t verticalAngel, uint8_t horizontalAngle)
{
    pantilt_set_angle_vertical(dev, verticalAngel);
    pantilt_set_angle_horizontal(dev, horizontalAngle);
}

/**
 * pantilt_shoot
 *
 * Fire the bullet.
 *
 * @param dev pantilt device structure.
 */
void pantilt_shoot(pantilt_dev *dev)
{
    // Need to compensate for inverted servo rotation.
    uint32_t duty_cycle_push = PANTILT_PWM_PERIOD_US * 13 / 200;
    uint32_t duty_cycle_neutral = PANTILT_PWM_PERIOD_US * 21 / 200;
    // duty_cycle = PANTILT_PWM_T_MAX_DUTY_CYCLE_US - duty_cycle + PANTILT_PWM_T_MIN_DUTY_CYCLE_US;

    pantilt_start_trigger(dev);

    pwm_configure(&(dev->pwm_t),
                  duty_cycle_push,
                  PANTILT_PWM_PERIOD_US,
                  PANTILT_PWM_CLOCK_FREQ_HZ);

    usleep(150000);

    pwm_configure(&(dev->pwm_t),
                  duty_cycle_neutral,
                  PANTILT_PWM_PERIOD_US,
                  PANTILT_PWM_CLOCK_FREQ_HZ);

    usleep(150000);

    // pantilt_stop_trigger(dev);
}

/**
 * pantilt_calculate_duty
 *
 * Calculate the duty cycle needed for an angle.
 *
 * @param angle in degrees [0-180].
 * @return duty_cycle pwm duty cycle in us.
 */
uint32_t pantilt_calculate_duty(uint8_t angle)
{
    uint32_t duty_cycle = PANTILT_PWM_H_MIN_DUTY_CYCLE_US + ((double)(PANTILT_PWM_H_MAX_DUTY_CYCLE_US - PANTILT_PWM_H_MIN_DUTY_CYCLE_US) * (double)angle / 180.0f);
    return duty_cycle;
}

/**
 * pantilt_start_vertical
 *
 * Starts the vertical pwm controller.
 *
 * @param dev pantilt device structure.
 */
void pantilt_start_vertical(pantilt_dev *dev)
{
    pwm_start(&(dev->pwm_v));
}

/**
 * pantilt_start_horizontal
 *
 * Starts the horizontal pwm controller.
 *
 * @param dev pantilt device structure.
 */
void pantilt_start_horizontal(pantilt_dev *dev)
{
    pwm_start(&(dev->pwm_h));
}

/**
 * pantilt_start_trigger
 *
 * Starts the trigger pwm controller.
 *
 * @param dev pantilt device structure.
 */
void pantilt_start_trigger(pantilt_dev *dev)
{
    pwm_start(&(dev->pwm_t));
}

/**
 * pantilt_stop_vertical
 *
 * Stops the vertical pwm controller.
 *
 * @param dev pantilt device structure.
 */
void pantilt_stop_vertical(pantilt_dev *dev)
{
    pwm_stop(&(dev->pwm_v));
}

/**
 * pantilt_stop_horizontal
 *
 * Stops the horizontal pwm controller.
 *
 * @param dev pantilt device structure.
 */
void pantilt_stop_horizontal(pantilt_dev *dev)
{
    pwm_stop(&(dev->pwm_h));
}

/**
 * pantilt_stop_trigger
 *
 * Stops the trigger pwm controller.
 *
 * @param dev pantilt device structure.
 */
void pantilt_stop_trigger(pantilt_dev *dev)
{
    pwm_stop(&(dev->pwm_t));
}
