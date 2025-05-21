#include <xil_types.h>
#include <xil_io.h>

#ifndef SRC_RF_DRIVERS_H_
#define SRC_RF_DRIVERS_H_

typedef struct registerControl{
	u32 BaseAddress;
}registerControl;

void initRegFile(registerControl *myReg, u32 BaseAddress);

void writeRegFile(registerControl *myReg, u32 writeEnable, u32 writeAddress, u32 writeData);

u32 readRegFileR1(registerControl *myReg, u32 writeAddress);

u32 readRegFileR2(registerControl *myReg, u32 writeAddress);

void resetRegFile(registerControl *myReg, u32 resetSignal);

void writeDisable(registerControl *myReg, u32 writeDisableSignal);

void scanEnable(registerControl *myReg, u32 scanEnableSignal);

#endif
