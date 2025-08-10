/*****************************************************
Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>

#include <delay.h>

// Standard Input/Output functions
#include <stdio.h>

#define ADC_VREF_TYPE 0x40
volatile char newdata = 0;
volatile char transmit_times = 0;
unsigned int adc_value;

// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
ADCSRA |= (1 << ADIF); 

// Read the AD conversion result
adc_value = ADCW;

newdata = 1;
// putchar('A');
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 16000.000 kHz
// Mode: Normal top=0xFFFF
TCCR1A=0x00;
TCCR1B=0x01;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;


// External Interrupt(s) initialization
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

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
UCSRB |= (1 << RXCIE);
UCSRB |= (1 << TXCIE);

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
// SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: Timer1 Overflow
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0xAC;
SFIOR&=0x1F;
SFIOR|=0xC0;


// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here 
          printf("adc_value: %d\n", adc_value);

      if (newdata == 1)
        {
        newdata = 0;  
        transmit_times++;  
        }
      
      if (transmit_times == 1) {putchar('1');}
      if (transmit_times == 2) {putchar('2');}
      
        }

}
