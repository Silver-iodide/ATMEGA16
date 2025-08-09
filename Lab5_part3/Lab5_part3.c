/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 8/19/2024
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

// 1 Wire Bus interface functions
#include <1wire.h>

// DS1820 Temperature Sensor functions
#include <ds1820.h>

// Delay function
#include <delay.h>

// Declare your global variables here
#define DQ_0    PORTC.7=0
#define DQ_1    PORTC.7=1
#define DQ_OUT  DDRC.7=1
#define DQ_IN   DDRC.7=0
#define DQ      PINC.7
int counter = 0;


#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)


// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0)
      {
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
#endif
      rx_buffer_overflow=1;
      }
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// Function prototypes
unsigned int read_tem(void);
void display_tem(unsigned int tem);

// Timer1 compare match interrupt service routine
interrupt [TIM1_COMPA] void awesome(void)
{
// Place your code here
counter++;

if (counter >= 2) 
    {
    counter = 0;    
    printf("INTERRUPT Triggered");
    display_tem(read_tem());
    }
}

// Temperature sensor Reset Function
void reset()
{
DQ_OUT;
DQ_0;
// delay_us(480);
delay_us(500);
DQ_1;
delay_us(60);
DQ_IN;      // What happens if we don't have pull-up resistor? 
while(DQ);
while(!DQ);
}

// Sensor write function
void write(unsigned char data)
{
unsigned char i;
DQ_OUT;
for (i = 0;i<8;i++) 
    {
    DQ_0;
    delay_us(10); 
    
    if(data&0x01) 
    {DQ_1;}
    else {DQ_0;}  
    
    delay_us(40);
    DQ_1;
    delay_us(1);
    data >>= 1; 
  
    }

}

// Sensor read function
// Read the data sent from the sensor 
unsigned char read()
{

unsigned char i,temp;
for(i=0;i<8;i++)
    {
    // Initialize the sensor with low level input 
    DQ_OUT;
    DQ_0;         
    // I suppose the DQ might not receive 0 if there is no time delay.
    delay_us(2);
    // set up the MCU by switching to input mode with pull-up resistor    
    DQ_1; 
    DQ_IN; 
    // Read the PIN and determine the current bit value
    if(DQ) 
        {
        temp |= 0x80;} 
    
    temp >>= 1;  
    delay_us(45); 
    // 
    }
return temp;
}

// Read temperature function
// OUTPUT: temperature unsigned int value
unsigned int read_tem()
{
unsigned int tem1, tem2;
reset();
write(0xCC);
write(0x44);
reset();
write(0xCC);
write(0xBE);

tem1 = read();
tem2 = read();
return ((tem2<<8) | tem1) * 6.25;
}

// display temperature to monitor function
void display_tem(unsigned int tem)
{
int ten, one, dat, dat1;
ten = tem/1000 + 0x30;
one = tem%1000/100 + 0x30;
dat = tem%100/10 + 0x30;
dat1= tem%10 + 0x30;

printf("T = ");
// lcd_putchar(ten);
putchar(one);
putchar(dat);
putchar(0x2E);
putchar(dat1);
printf("C");
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
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: CTC top=OCR1A
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x0D;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x98;
OCR1AL=0x96;
OCR1BH=0x00;
OCR1BL=0x00;

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
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK |= (1 << OCIE1A);  // Enable Timer1 Compare Match A interrupt

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x67;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// 1 Wire Bus initialization
// 1 Wire Data port: PORTC
// 1 Wire Data bit: 7
// Note: 1 Wire port settings must be specified in the
// Project|Configure|C Compiler|Libraries|1 Wire IDE menu.
w1_init();

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here  
      /*
      unsigned int tcnt1_value;

      tcnt1_value = TCNT1L;           // Read low byte first
      tcnt1_value |= (TCNT1H << 8);   // Read high byte and combine

      printf("TCNT1 Value: %u\n", tcnt1_value);
      delay_ms(1000); 
      */
      }
}
