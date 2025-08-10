/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 8/23/2024
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>
#include <delay.h>
//#include <fdacoefs.h>
//#include <tmwtypes.h>
// Alphanumeric LCD Module functions
#include <alcd.h>
#include <stdio.h>

// Declare your global variables here
#define ADC_VREF_TYPE 0x40
char counter = 10;
char SAMPLE_POINT = 127; // Number of data needed to be sent to serial port
char new_unfiltered_data;
// Buffer to store the last 61 samples, used for FIR conversion since there are only 61 coefficient exists
unsigned int adc_data[61];  
           
unsigned int unfiltered_data[SAMPLE_POINT];  // Buffer to store 127 unfiltered samples
long filtered_data[SAMPLE_POINT];            // Buffer to store 127 filtered samples

char filter_index = 0;
char sample_index = 0;
unsigned char checkADCLoop = 0;
char newdata = 0;
// Storing FIR filter coefficients in Flash memory
flash int B[61] = {
        0,      1,      2,      3,      3,      0,     -9,    -25,    -50,
      -85,   -129,   -179,   -229,   -271,   -292,   -279,   -217,    -91,
      111,    399,    775,   1235,   1767,   2350,   2957,   3556,   4111,
     4587,   4953,   5183,   5261,   5183,   4953,   4587,   4111,   3556,
     2957,   2350,   1767,   1235,    775,    399,    111,    -91,   -217,
     -279,   -292,   -271,   -229,   -179,   -129,    -85,    -50,    -25,
       -9,      0,      3,      3,      2,      1,      0};




// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here

}

// Standard Input/Output functions
#include <stdio.h>

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0xB2;
// ToDo:
// Status: Done
counter--;

if (counter == 0)
    {
    counter = 5;
    PORTA.2 = ~PORTA.2;
    }
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here

}


void trans_data(int xl)
{
unsigned char H5,L5;
unsigned int AD_x;
AD_x = xl & 0x3FFF;
H5 = AD_x>>5;
L5 = AD_x & 0x1F;
putchar(L5+11);
putchar(H5+51);
}


// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
unsigned int adc_data;
// Read the AD conversion result
adc_data=ADCW;
// Place your code here
// Check whether this mode could provide 500Hz data to serial port
newdata = 1;
checkADCLoop++; 

if (checkADCLoop == 127) {checkADCLoop = 0;}

}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x05;
TCNT0=0xB2;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 2000.000 kHz
// Mode: Ph. & fr. cor. PWM top=ICR1
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
//TCCR1A=0x00;
//TCCR1B=0x12;
//TCNT1H=0x00;
//TCNT1L=0x00;
//ICR1H=0x07;
//ICR1L=0xD0;
//OCR1AH=0x00;
//OCR1AL=0x00;
//OCR1BH=0x00;
//OCR1BL=0xD0;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 16.000 MHz (with prescaler = 1)
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A = 0x00;
TCCR1B = 0x01;  // Set WGM12:0 to 0b000 for Normal mode, CS12:0 to 0b001 for prescaler = 1
TCNT1H = 0x00;
TCNT1L = 0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x02;
MCUCSR=0x00;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x05;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x67;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization Not used!!!!!!!!!!!!!!!!!
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: Timer1 Capture Event
//ADMUX=ADC_VREF_TYPE & 0xff;
//ADCSRA=0xAF;
//SFIOR&=0x1F;
//SFIOR|=0xE0;

//  New ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: Timer1 Overflow
ADMUX = ADC_VREF_TYPE & 0xff;
ADCSRA = 0xAF;
SFIOR &= 0x1F;  // Clear the ADTS bits
SFIOR |= 0x20;  // Set the ADTS to 0x20 for Timer1 Overflow


// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 0
// RD - PORTB Bit 1
// EN - PORTB Bit 2
// D4 - PORTD Bit 4
// D5 - PORTD Bit 5
// D6 - PORTD Bit 6
// D7 - PORTD Bit 7
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
      if (newdata == 1)
        {
        printf("%d", checkADCLoop);
        newdata = 0;
        }
      }
}
