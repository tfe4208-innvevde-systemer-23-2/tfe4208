#ifndef __PERIPHERAL_H__
#define __PERIPHERAL_H__

#define PERIPHERAL_XCORR_BITS	6

#define PERIPHERAL_MASK_FIRST	(0x3f << PERIPHERAL_XCORR_BITS * 0)
#define PERIPHERAL_MASK_SECOND	(0x3f << PERIPHERAL_XCORR_BITS * 1)
#define PERIPHERAL_MASK_THIRD	(0x3f << PERIPHERAL_XCORR_BITS * 2)

#define PERIPHERAL_ADDR_LOWER	(0 * 4)
#define PERIPHERAL_ADDR_UPPER	(1 * 4)

#include <stdint.h>

/* peripheral device structure */
typedef struct peripheral_dev {
	void *base; /* Base address of component */
} peripheral_dev;

/* Lags data structure */
typedef struct peripheral_lags{
	uint8_t *l01, l02, l03, l12, l13, l23;
} peripheral_lags;

/*******************************************************************************
 *  Public API
 ******************************************************************************/
peripheral_dev peripheral_inst(void *base);

uint32_t peripheral_read(peripheral_dev *dev, uint8_t address);
uint32_t peripheral_read_upper(peripheral_dev *dev);
uint32_t peripheral_read_lower(peripheral_dev *dev);

void getLags(peripheral_dev *dev, peripheral_lags *lags);

#endif /* __PERIPHERAL_H__ */
