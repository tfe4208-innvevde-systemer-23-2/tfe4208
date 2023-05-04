#include <math.h>
#include "Sanity.h"

double calculateAngle(peripheral_lags* lags) {
    return atan2(sqrt(3) * (lags->t01 + lags->t02), (lags->t01 - lags->t02 - (2 * lags->t12)));
}