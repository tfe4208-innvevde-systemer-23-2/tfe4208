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

uint32_t peripheral_read_upper(peripheral_dev *dev) {
	return peripheral_read(dev->base, PERIPHERAL_ADDR_UPPER);
}

uint32_t peripheral_read_lower(peripheral_dev *dev) {
	return peripheral_read(dev->base, PERIPHERAL_ADDR_LOWER);
}

void getLags(peripheral_dev *dev, peripheral_lags *lags) {
	uint32_t temp = peripheral_read_lower(dev->base);
	lags->l01 = (temp & PERIPHERAL_MASK_FIRST);
	lags->l02 = ((temp & PERIPHERAL_MASK_SECOND) >> 6);
	lags->l03 = ((temp & PERIPHERAL_MASK_THIRD) >> 12);
	temp = peripheral_read_upper(dev->base);
	lags->l12 = (temp & PERIPHERAL_MASK_FIRST);
	lags->l13 = ((temp & PERIPHERAL_MASK_SECOND) >> 6);
	lags->l23 = ((temp & PERIPHERAL_MASK_THIRD) >> 12);
}
