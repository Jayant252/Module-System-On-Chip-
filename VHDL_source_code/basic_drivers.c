#include "basic_drivers.h"
#include <unistd.h>


void initRegFile(registerControl *myReg, u32 BaseAddress)
{
	myReg->BaseAddress = BaseAddress;
}

void writeRegFile(registerControl *myReg, u32 writeEnable, u32 writeAddress, u32 writeData)
{
	Xil_Out32(((myReg->BaseAddress)+4), writeEnable);
	Xil_Out32(((myReg->BaseAddress)+16), writeAddress);
	Xil_Out32(((myReg->BaseAddress)+20), writeData);
}

u32 readRegFileR1(registerControl *myReg, u32 writeAddress)
{
	Xil_Out32(((myReg->BaseAddress)+8), writeAddress);
	sleep(1);
	return Xil_In32((myReg->BaseAddress)+28);
}

u32 readRegFileR2(registerControl *myReg, u32 writeAddress)
{
	Xil_Out32(((myReg->BaseAddress)+12), writeAddress);
	sleep(1);
	return Xil_In32((myReg->BaseAddress)+28);
}

void resetRegFile(registerControl *myReg, u32 resetSignal)
{
	Xil_Out32(myReg->BaseAddress, resetSignal);
}

void writeDisable(registerControl *myReg, u32 writeDisableSignal)
{
	Xil_Out32(((myReg->BaseAddress)+4), writeDisableSignal);
}

void scanEnable(registerControl *myReg, u32 scanEnableSignal)
{
	Xil_Out32(((myReg->BaseAddress)+24), scanEnableSignal);
}
