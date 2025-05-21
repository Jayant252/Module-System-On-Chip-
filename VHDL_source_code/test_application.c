#include "basic_drivers.h"
#include <xil_types.h>
#include <xparameters.h>
#include <xil_printf.h>

int main()
{
	registerControl myRegFile;

	initRegFile(&myRegFile, XPAR_TOP_IP_0_BASEADDR);

	scanEnable(&myRegFile, 0x00000000);

	resetRegFile(&myRegFile, 0x00000001);

	writeRegFile(&myRegFile, 0x00000000, 0x00000000, 0xBABABABA);

	writeRegFile(&myRegFile, 0x00000000, 0x00000001, 0xDADADADA);

	writeDisable(&myRegFile, 0x00000001);

	u32 readData1 = readRegFileR1(&myRegFile, 0x00000000);

	u32 readData2 = readRegFileR2(&myRegFile, 0x00000001);

	xil_printf("Data written in R0 is %x\n\r", readData1);

	xil_printf("Data written in R1 is %x\n\r", readData2);

	resetRegFile(&myRegFile, 0x00000000);

	xil_printf("Reg File reset\n\r");

	readData1 = readRegFileR1(&myRegFile, 0x00000000);

	readData2 = readRegFileR2(&myRegFile, 0x00000001);

	xil_printf("Data written in R0 is %x\n\r", readData1);

	xil_printf("Data written in R1 is %x\n\r", readData2);

	return 0;
}
