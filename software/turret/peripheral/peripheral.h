#ifndef __PERIPHERAL_H__
#define __PERIPHERAL_H__

#define PERIPHERAL_XCORR_BITS	5

#define PERIPHERAL_MASK_LAGS	0x1f	// 5'b11111
#define PERIPHERAL_MASK_FLAGS	0x3		// 2'b11

#define PERIPHERAL_ADDR_LAGS	(0 * 4)
#define PERIPHERAL_ADDR_DEBUG	(1 * 4)

#include <stdint.h>

/* peripheral device structure */
typedef struct peripheral_dev {
	void *base; /* Base address of component */
} peripheral_dev;

/* Lags data structure */
typedef struct peripheral_lags{
	char t01, t02, t03, t12, t13, t23;
	uint8_t flags;
} peripheral_lags;

/*******************************************************************************
 *  Public API
 ******************************************************************************/
peripheral_dev peripheral_inst(void *base);

uint32_t peripheral_read(peripheral_dev *dev, uint8_t address);
uint32_t peripheral_read_debug(peripheral_dev *dev);
uint32_t peripheral_read_lags(peripheral_dev *dev);

void getLags(peripheral_dev *dev, peripheral_lags *lags);

//void setThreshold(peripheral_dev *dev, uint32_t threshold);	// TODO: Set a configurable threshold

#endif /* __PERIPHERAL_H__ */
