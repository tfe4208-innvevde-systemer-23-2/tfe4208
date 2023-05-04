#include <io.h>

#include "peripheral.h"

/**
 * peripheral_inst
 *
 * Instantiate a peripheral device structure.
 *
 * @param base Base address of the component.
 */
peripheral_dev peripheral_inst(void *base) {
	peripheral_dev dev;

	dev.base = base;

	return dev;
}

uint32_t peripheral_read(peripheral_dev *dev, uint8_t address) {
	return IORD_32DIRECT(dev->base, address);
}

uint32_t peripheral_read_debug(peripheral_dev *dev) {
	return peripheral_read(dev, PERIPHERAL_ADDR_DEBUG);
}

uint32_t peripheral_read_lags(peripheral_dev *dev) {
	return peripheral_read(dev, PERIPHERAL_ADDR_LAGS);
}

void getLags(peripheral_dev *dev, peripheral_lags *lags) {
	uint32_t temp = peripheral_read_lags(dev);
	lags->t01 = ((22 - (temp >> (0 * PERIPHERAL_XCORR_BITS))) & PERIPHERAL_MASK_LAGS) - 11;
	lags->t02 = ((22 - (temp >> (1 * PERIPHERAL_XCORR_BITS))) & PERIPHERAL_MASK_LAGS) - 11;
	lags->t03 = ((22 - (temp >> (2 * PERIPHERAL_XCORR_BITS))) & PERIPHERAL_MASK_LAGS) - 11; // Number 2 and 3 seem to be swapped
	lags->t12 = ((22 - (temp >> (3 * PERIPHERAL_XCORR_BITS))) & PERIPHERAL_MASK_LAGS) - 11; // at some point WTF THIS CHANGES RANDOMLY???
	lags->t13 = ((22 - (temp >> (4 * PERIPHERAL_XCORR_BITS))) & PERIPHERAL_MASK_LAGS) - 11;
	lags->t23 = ((22 - (temp >> (5 * PERIPHERAL_XCORR_BITS))) & PERIPHERAL_MASK_LAGS) - 11;
	lags->flags = (temp >> (6 * PERIPHERAL_XCORR_BITS)) & PERIPHERAL_MASK_FLAGS;		  // [dataEnable, Shoot]
}
