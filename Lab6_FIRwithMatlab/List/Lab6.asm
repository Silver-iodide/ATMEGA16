
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _counter=R5
	.DEF _SAMPLE_POINT=R4
	.DEF _new_unfiltered_data=R7
	.DEF _filter_index=R6
	.DEF _sample_index=R9
	.DEF __lcd_x=R8
	.DEF __lcd_y=R11
	.DEF __lcd_maxx=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_B:
	.DB  0x0,0x0,0x1,0x0,0x2,0x0,0x3,0x0
	.DB  0x3,0x0,0x0,0x0,0xF7,0xFF,0xE7,0xFF
	.DB  0xCE,0xFF,0xAB,0xFF,0x7F,0xFF,0x4D,0xFF
	.DB  0x1B,0xFF,0xF1,0xFE,0xDC,0xFE,0xE9,0xFE
	.DB  0x27,0xFF,0xA5,0xFF,0x6F,0x0,0x8F,0x1
	.DB  0x7,0x3,0xD3,0x4,0xE7,0x6,0x2E,0x9
	.DB  0x8D,0xB,0xE4,0xD,0xF,0x10,0xEB,0x11
	.DB  0x59,0x13,0x3F,0x14,0x8D,0x14,0x3F,0x14
	.DB  0x59,0x13,0xEB,0x11,0xF,0x10,0xE4,0xD
	.DB  0x8D,0xB,0x2E,0x9,0xE7,0x6,0xD3,0x4
	.DB  0x7,0x3,0x8F,0x1,0x6F,0x0,0xA5,0xFF
	.DB  0x27,0xFF,0xE9,0xFE,0xDC,0xFE,0xF1,0xFE
	.DB  0x1B,0xFF,0x4D,0xFF,0x7F,0xFF,0xAB,0xFF
	.DB  0xCE,0xFF,0xE7,0xFF,0xF7,0xFF,0x0,0x0
	.DB  0x3,0x0,0x3,0x0,0x2,0x0,0x1,0x0
	.DB  0x0,0x0
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0xE:
	.DB  0x7F,0xA,0x0,0x0,0x0,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  _0xE*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 8/20/2024
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;//#include <fdacoefs.h>
;//#include <tmwtypes.h>
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;#include <stdio.h>
;
;// Declare your global variables here
;#define ADC_VREF_TYPE 0x40
;char counter = 10;
;char SAMPLE_POINT = 127; // Number of data needed to be sent to serial port
;char new_unfiltered_data;
;// Buffer to store the last 61 samples, used for FIR conversion since there are only 61 coefficient exists
;unsigned int adc_data[61];
;
;unsigned int unfiltered_data[SAMPLE_POINT];  // Buffer to store 127 unfiltered samples
;long filtered_data[SAMPLE_POINT];            // Buffer to store 127 filtered samples
;
;char filter_index = 0;
;char sample_index = 0;
;
;// Storing FIR filter coefficients in Flash memory
;flash int B[61] = {
;        0,      1,      2,      3,      3,      0,     -9,    -25,    -50,
;      -85,   -129,   -179,   -229,   -271,   -292,   -279,   -217,    -91,
;      111,    399,    775,   1235,   1767,   2350,   2957,   3556,   4111,
;     4587,   4953,   5183,   5261,   5183,   4953,   4587,   4111,   3556,
;     2957,   2350,   1767,   1235,    775,    399,    111,    -91,   -217,
;     -279,   -292,   -271,   -229,   -179,   -129,    -85,    -50,    -25,
;       -9,      0,      3,      3,      2,      1,      0};
;
;
;
;/*****************************************
;External Interrupt 0 service routine:
;This is for changing the mode of FIR among
;Lowpass, highpass, bandpass, bandstop filter
;*******************************************/
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0040 {

	.CSEG
_ext_int0_isr:
; 0000 0041 // ToDo:
; 0000 0042 
; 0000 0043 }
	RETI
;
;
;/***********************************************
;Timer 0 overflow interrupt service routine
;Used for generating 10Hz square wave to PA2.
;************************************/
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 004B {
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 004C // Reinitialize Timer 0 value
; 0000 004D TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 004E // ToDo:
; 0000 004F // Status: Done
; 0000 0050 counter--;
	DEC  R5
; 0000 0051 
; 0000 0052 if (counter == 0)
	TST  R5
	BRNE _0x3
; 0000 0053     {
; 0000 0054     counter = 10;
	LDI  R30,LOW(10)
	MOV  R5,R30
; 0000 0055     PORTA.2 = ~PORTA.2;
	SBIS 0x1B,2
	RJMP _0x4
	CBI  0x1B,2
	RJMP _0x5
_0x4:
	SBI  0x1B,2
_0x5:
; 0000 0056     }
; 0000 0057 }
_0x3:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;// Timer1 output compare A interrupt service routine
;// NOT USED since ADC is auto triggered by the Timer1 Compare Match
;//interrupt [TIM1_COMPA] void timer1_compa_isr(void)
;//{
;//
;//}
;
;
;void trans_data(int xl)
; 0000 0062 {
; 0000 0063 unsigned char H5,L5;
; 0000 0064 unsigned int AD_x;
; 0000 0065 AD_x = xl & 0x3FFF;
;	xl -> Y+4
;	H5 -> R17
;	L5 -> R16
;	AD_x -> R18,R19
; 0000 0066 H5 = AD_x>>5;
; 0000 0067 L5 = AD_x & 0x1F;
; 0000 0068 putchar(L5+11);
; 0000 0069 putchar(H5+51);
; 0000 006A }
;
;
;/*****************************
;ADC interrupt service routine:
;Do the AD conversion and perform the FIR filter operation.
;************************************************/
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0072 {
_adc_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0073 // ToDo:
; 0000 0074 // Do the FIR filter operation and store both unfiltered and filtered data;
; 0000 0075 // After the filtered data reaches 127#, send both the original
; 0000 0076 // and filtered data to serial port
; 0000 0077 
; 0000 0078 unsigned int adc_value;        // Variable storing AD conversion result
; 0000 0079 
; 0000 007A // Read the AD conversion result
; 0000 007B adc_value = ADCW;
	ST   -Y,R17
	ST   -Y,R16
;	adc_value -> R16,R17
	__INWR 16,17,4
; 0000 007C adc_data[filter_index] = adc_value;
	MOV  R30,R6
	CALL SUBOPT_0x0
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
	STD  Z+1,R17
; 0000 007D unfiltered_data[sample_index] = adc_value;  // Store unfiltered sample
	MOV  R30,R9
	LDI  R26,LOW(_unfiltered_data)
	LDI  R27,HIGH(_unfiltered_data)
	CALL SUBOPT_0x1
	ST   Z,R16
	STD  Z+1,R17
; 0000 007E 
; 0000 007F sample_index++;
	INC  R9
; 0000 0080 // Which condition to apply FIR? Answer: after adc_isr triggered, which represents new values has been plug in.
; 0000 0081 new_unfiltered_data = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0082 // printf("%d", sample_index);
; 0000 0083 // main function checking frequency is much higher than the adc_isr
; 0000 0084 
; 0000 0085 }
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;
;void main(void)
; 0000 0089 {
_main:
; 0000 008A // Declare your local variables here
; 0000 008B char i,j,k;
; 0000 008C // Input/Output Ports initialization
; 0000 008D // Port A initialization
; 0000 008E PORTA=0x00;
;	i -> R17
;	j -> R16
;	k -> R19
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 008F DDRA=0x02;      // set PA2 as output
	LDI  R30,LOW(2)
	OUT  0x1A,R30
; 0000 0090 
; 0000 0091 // Port B initialization
; 0000 0092 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0093 DDRB=0x00;
	OUT  0x17,R30
; 0000 0094 
; 0000 0095 // Port C initialization
; 0000 0096 PORTC=0x00;
	OUT  0x15,R30
; 0000 0097 DDRC=0x00;
	OUT  0x14,R30
; 0000 0098 
; 0000 0099 // Port D initialization
; 0000 009A PORTD=0x00;
	OUT  0x12,R30
; 0000 009B DDRD=0x00;
	OUT  0x11,R30
; 0000 009C 
; 0000 009D // Timer/Counter 0 initialization
; 0000 009E // Clock source: System Clock
; 0000 009F // Clock value: 15.625 kHz
; 0000 00A0 // Mode: Normal top=0xFF
; 0000 00A1 // OC0 output: Disconnected
; 0000 00A2 TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00A3 TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 00A4 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 00A5 
; 0000 00A6 // Timer/Counter 1 initialization
; 0000 00A7 // Clock source: System Clock
; 0000 00A8 // Clock value: 62.500 kHz
; 0000 00A9 // Mode: CTC top=OCR1A
; 0000 00AA // OC1A output: Discon.
; 0000 00AB // OC1B output: Discon.
; 0000 00AC // Noise Canceler: Off
; 0000 00AD // Input Capture on Falling Edge
; 0000 00AE // Timer1 Overflow Interrupt: Off
; 0000 00AF // Input Capture Interrupt: Off
; 0000 00B0 // Compare A Match Interrupt: On
; 0000 00B1 // Compare B Match Interrupt: Off
; 0000 00B2 //TCCR1A=0x00;
; 0000 00B3 //TCCR1B=0x0C;
; 0000 00B4 //TCNT1H=0x00;
; 0000 00B5 //TCNT1L=0x00;
; 0000 00B6 //ICR1H=0x00;
; 0000 00B7 //ICR1L=0x00;
; 0000 00B8 //OCR1AH=0x00;
; 0000 00B9 //OCR1AL=0xF9;
; 0000 00BA //OCR1BH=0x00;
; 0000 00BB //OCR1BL=0xF9;
; 0000 00BC 
; 0000 00BD // Timer/Counter 1 initialization
; 0000 00BE // Clock source: System Clock
; 0000 00BF // Clock value: 62.500 kHz (F_CPU / 256)
; 0000 00C0 // Mode: CTC top=ICR1
; 0000 00C1 // OC1A output: Disconnected
; 0000 00C2 // OC1B output: Disconnected
; 0000 00C3 TCCR1A = 0x00; // CTC mode
	OUT  0x2F,R30
; 0000 00C4 TCCR1B = 0x0C; // CTC mode with ICR1 as top, prescaler = 256
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 00C5 TCNT1H = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00C6 TCNT1L = 0x00;
	OUT  0x2C,R30
; 0000 00C7 ICR1H = 0x00;  // Set ICR1 to the desired top value
	OUT  0x27,R30
; 0000 00C8 ICR1L = 0xF9; // Set ICR1 to 249 for 250Hz
	LDI  R30,LOW(249)
	OUT  0x26,R30
; 0000 00C9 
; 0000 00CA // Timer/Counter 2 initialization
; 0000 00CB // Clock source: System Clock
; 0000 00CC // Clock value: Timer2 Stopped
; 0000 00CD // Mode: Normal top=0xFF
; 0000 00CE // OC2 output: Disconnected
; 0000 00CF ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 00D0 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00D1 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00D2 OCR2=0x00;
	OUT  0x23,R30
; 0000 00D3 
; 0000 00D4 // External Interrupt(s) initialization
; 0000 00D5 // INT0: On
; 0000 00D6 // INT0 Mode: Falling Edge
; 0000 00D7 // INT1: Off
; 0000 00D8 // INT2: Off
; 0000 00D9 GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 00DA MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 00DB MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00DC GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 00DD 
; 0000 00DE // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00DF TIMSK=0x11;
	LDI  R30,LOW(17)
	OUT  0x39,R30
; 0000 00E0 
; 0000 00E1 // USART initialization
; 0000 00E2 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00E3 // USART Receiver: On
; 0000 00E4 // USART Transmitter: On
; 0000 00E5 // USART Mode: Asynchronous
; 0000 00E6 // USART Baud Rate: 9600
; 0000 00E7 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00E8 UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 00E9 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00EA UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00EB UBRRL=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 00EC 
; 0000 00ED // Analog Comparator initialization
; 0000 00EE // Analog Comparator: Off
; 0000 00EF // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00F0 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00F1 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00F2 
; 0000 00F3 // ADC initialization
; 0000 00F4 // ADC Clock frequency: 250.000 kHz
; 0000 00F5 // ADC Voltage Reference: AVCC pin
; 0000 00F6 // ADC Auto Trigger Source: Timer1 Compare Match B
; 0000 00F7 ADMUX=(ADC_VREF_TYPE & 0xff) | (1 << MUX2) | (1 << MUX0);    //ADMUX |= (1 << 0) will set ADMUX's first bit to 1.
	LDI  R30,LOW(69)
	OUT  0x7,R30
; 0000 00F8 ADCSRA=0xAE;
	LDI  R30,LOW(174)
	OUT  0x6,R30
; 0000 00F9 SFIOR&=0x1F;
	IN   R30,0x30
	ANDI R30,LOW(0x1F)
	OUT  0x30,R30
; 0000 00FA SFIOR|=0xE0;   // Change, I dont know what will happen!!!!!!!!!!!!!!!!!1
	IN   R30,0x30
	ORI  R30,LOW(0xE0)
	OUT  0x30,R30
; 0000 00FB 
; 0000 00FC // SPI initialization
; 0000 00FD // SPI disabled
; 0000 00FE SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00FF 
; 0000 0100 // TWI initialization
; 0000 0101 // TWI disabled
; 0000 0102 TWCR=0x00;
	OUT  0x36,R30
; 0000 0103 
; 0000 0104 // Alphanumeric LCD initialization
; 0000 0105 // Connections specified in the
; 0000 0106 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0107 // RS - PORTB Bit 0
; 0000 0108 // RD - PORTB Bit 1
; 0000 0109 // EN - PORTB Bit 2
; 0000 010A // D4 - PORTD Bit 4
; 0000 010B // D5 - PORTD Bit 5
; 0000 010C // D6 - PORTD Bit 6
; 0000 010D // D7 - PORTD Bit 7
; 0000 010E // Characters/line: 8
; 0000 010F lcd_init(8);
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 0110 
; 0000 0111 // Global enable interrupts
; 0000 0112 #asm("sei")
	sei
; 0000 0113 
; 0000 0114 while (1)
_0x6:
; 0000 0115       {
; 0000 0116       // Place your code here
; 0000 0117       if (new_unfiltered_data == 1)
	LDI  R30,LOW(1)
	CP   R30,R7
	BREQ PC+3
	JMP _0x9
; 0000 0118         {
; 0000 0119         long filtered_output = 0;      // Variable storing one filtered data once at a time
; 0000 011A 
; 0000 011B         // printf("newdata_in");
; 0000 011C         j = filter_index;
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
;	filtered_output -> Y+0
	MOV  R16,R6
; 0000 011D         for (i = 0; i < 61; i++)
	LDI  R17,LOW(0)
_0xB:
	CPI  R17,61
	BRSH _0xC
; 0000 011E         {
; 0000 011F             j = (j - i + 60) % 61;  // Circular buffer handling
	MOV  R26,R16
	CLR  R27
	MOV  R30,R17
	LDI  R31,0
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ADIW R30,60
	MOVW R26,R30
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	CALL __MODW21
	MOV  R16,R30
; 0000 0120             filtered_output += (long)adc_data[j] * B[i];    // B[61] is declared in fdacoef.h file
	MOV  R30,R16
	CALL SUBOPT_0x0
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CLR  R22
	CLR  R23
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R17
	LDI  R26,LOW(_B*2)
	LDI  R27,HIGH(_B*2)
	CALL SUBOPT_0x1
	CALL __GETW1PF
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CWD1
	CALL __MULD12
	CALL __GETD2S0
	CALL __ADDD12
	CALL __PUTD1S0
; 0000 0121         }
	SUBI R17,-1
	RJMP _0xB
_0xC:
; 0000 0122 
; 0000 0123         // Store filtered result
; 0000 0124         filtered_data[sample_index-1] = filtered_output;
	MOV  R30,R9
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(_filtered_data)
	LDI  R27,HIGH(_filtered_data)
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETD2S0
	CALL __PUTDZ20
; 0000 0125 
; 0000 0126         // Update buffer and sample indices
; 0000 0127         filter_index = (filter_index + 1) % 61;
	MOV  R30,R6
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	CALL __MODW21
	MOV  R6,R30
; 0000 0128         // sample_index += 1;
; 0000 0129         // printf("%d", sample_index);
; 0000 012A         putchar('A');
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _putchar
; 0000 012B         new_unfiltered_data = 0; // set back to 0 and wait until new data input
	CLR  R7
; 0000 012C 
; 0000 012D         // Test whether the sample_index could reach 127
; 0000 012E         }
	ADIW R28,4
; 0000 012F 
; 0000 0130       // If 127 samples are collected, transmit data to Serial port
; 0000 0131 //      if (sample_index == SAMPLE_POINT)
; 0000 0132 //          {
; 0000 0133 //          // Transmit unfiltered and filtered data via USART
; 0000 0134 //          for (k = 0; k < SAMPLE_POINT; k++)
; 0000 0135 //                {
; 0000 0136 //                trans_data(unfiltered_data[k]);  // Send unfiltered data
; 0000 0137 //                }
; 0000 0138 //
; 0000 0139 //          for (k = 0; k < SAMPLE_POINT; k++)
; 0000 013A //                {
; 0000 013B //                trans_data(filtered_data[k]);  // Send filtered data (scaled to fit)
; 0000 013C //                }
; 0000 013D //
; 0000 013E //          putchar(10);      // For MATLAB Receiver
; 0000 013F //
; 0000 0140 //          // Reset sample index for the next batch
; 0000 0141 //          sample_index = 0;
; 0000 0142 //
; 0000 0143 //          }
; 0000 0144       }
_0x9:
	RJMP _0x6
; 0000 0145 }
_0xD:
	RJMP _0xD
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x12,4
	RJMP _0x2000005
_0x2000004:
	CBI  0x12,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x12,5
	RJMP _0x2000007
_0x2000006:
	CBI  0x12,5
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x12,6
	RJMP _0x2000009
_0x2000008:
	CBI  0x12,6
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x12,7
	RJMP _0x200000B
_0x200000A:
	CBI  0x12,7
_0x200000B:
	__DELAY_USB 11
	SBI  0x18,2
	__DELAY_USB 27
	CBI  0x18,2
	__DELAY_USB 27
	JMP  _0x2080001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x2080001
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2
	LDI  R30,LOW(0)
	MOV  R11,R30
	MOV  R8,R30
	RET
_lcd_init:
	SBI  0x11,4
	SBI  0x11,5
	SBI  0x11,6
	SBI  0x11,7
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LDD  R10,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
	RJMP _0x2080001
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2080001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.DSEG
_adc_data:
	.BYTE 0x7A
_unfiltered_data:
	.BYTE 0x2
_filtered_data:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_adc_data)
	LDI  R27,HIGH(_adc_data)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G100
	__DELAY_USW 400
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

;END OF CODE MARKER
__END_OF_CODE:
