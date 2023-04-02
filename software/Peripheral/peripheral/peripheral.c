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
	return peripheral_read(dev->base, 1);
}

uint32_t peripheral_read_lower(peripheral_dev *dev) {
	return peripheral_read(dev->base, 0);
}


