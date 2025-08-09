/*******************************************************
This program was created by the CodeWizardAVR V4.02 
Automatic Program Generator
© Copyright 1998-2024 Pavel Haiduc, HP InfoTech S.R.L.
http://www.hpinfotech.ro

Project :  Lab 2 Task 4-6
Version : 
Date    :  8/10/2024
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

// I/O Registers definitions
#include <mega16.h>
#include <delay.h>
// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here

}

// External Interrupt 0 service routine
// After pressing button 1, this interrupt will begin
// We need to light up LED1 and shut down LED2.
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
if (OCR0 <= 245){
    OCR0 += 10;
    }
}

// External Interrupt 1 service routine
// After pressing button 2, this interrupt will begin
// We need to light up LED2 and shut down LED1
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here
if (OCR0 > 10){
    OCR0 -= 10;
    }
}

// Declare your global variables here

// Note frequencies using calculated OCR0 values
#define C4  118
#define D4  105
#define E4  94
#define F4  88
#define G4  79
#define A4  70
#define B4  63
#define C5  58

// Game of Thrones

#define Eb5 47
#define G5  39
#define F5  45
#define D5  53
#define Bb4 66

// Function to play a note
void play_note(int ocr_value, int duration_ms) {
    OCR0 = ocr_value;  // Set OCR0 to the desired note frequency
    delay_ms(duration_ms);  // Play the note for the specified duration
    OCR0 = 0;  // Stop the note by setting OCR0 to 0
    delay_ms(50);  // Short delay between notes
}


void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization  (NOT USED!!!!)
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
// TCNT0=0x00;
// OCR0=0x00;

// New Timer/Counter 0 initialize (for TASK 5!!!!)
// CTC Mode, OCR0 set to #55, OC0 connected to PB3
// TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
// TCNT0=0x00;
// OCR0=0x37;

// Timer/Counter 0 initialize for TASK 6!!!!
// Fast PWM mode with inverting compare output mode, OCR0 set to #128, OC0 output to PB3.
// TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
// TCNT0=0x00;
// OCR0=0x80;

// New Timer/Counter 0 initialize (for TASK 5!!!!)
// CTC Mode, OCR0 set to 0 at first for the melody, OC0 connected to PB3
TCCR0=(0<<WGM00) | (0<<COM01) | (1<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 62.500 kHz
// Mode: CTC top=OCR1A
// OC1A output: Toggle on compare match
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0.5 s
// Output Pulse(s):
// OC1A Period: 1 s Width: 0.5 s
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x7A;
OCR1AL=0x11;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization (NOT USED!!!!)
// INT0: Off
// INT1: Off
// INT2: Off
// MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
// MCUCSR=(0<<ISC2);

// New External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: Off
GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);
MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Globally enable interrupts
#asm("sei")

// Task 4: Use a timer to make an LED blink at intervals of 0.5 seconds and 5 seconds.
// Status: Done
/**************************************
// set LED's pin PA3 with output signal. 
DDRA.3 = 1;

// OC1A output pin: PD5
while (1)
      {
      // Place your code here
      PORTA.3 = PIND.5;
      }
***************************************/


// Task 5: Control the frequency of a buzzer using buttons, 
// with one button to increase and one to decrease the frequency. 
// (Recommended square wave frequency is 400~1000Hz)
// Status: Done.
// DDRB.3 = 1;


// Task 6: Use buttons to control the intensity of the buzzer using the PWM method.
// Status: Done.
// DDRB.3 = 1;

// Extra Task: Play melody by controlling the buzzer's frequency.

// Set PB3 as output to the buzzer.
DDRB.3 = 1; 

// Set Timer/Counter0 to CTC mode
// We use task 5's TCCR setting

    while (1) {
        // Play a simple melody
        /*
        play_note(C4, 500);  // Play C4 for 500 ms
        play_note(D4, 500);  // Play D4 for 500 ms
        play_note(E4, 500);  // Play E4 for 500 ms
        play_note(F4, 500);  // Play F4 for 500 ms
        play_note(G4, 500);  // Play G4 for 500 ms
        play_note(A4, 500);  // Play A4 for 500 ms
        play_note(B4, 500);  // Play B4 for 500 ms
        play_note(C5, 500);  // Play C5 for 500 ms
        */
        // Play the chord progression: F - G - Em - Am - F - G - C
        /*
        play_note(F4, 500);  // Play F chord (first time)
        play_note(F4, 500);  // Play F chord (second time)
        play_note(G4, 500);  // Play G chord (first time)
        play_note(G4, 500);  // Play G chord (second time)
        play_note(E4, 500);  // Play Em chord (first time)
        play_note(E4, 500);  // Play Em chord (second time)
        play_note(A4, 500);  // Play Am chord (first time)
        play_note(A4, 500);  // Play Am chord (second time)
        play_note(F4, 500);  // Play F chord again (first time)
        play_note(F4, 500);  // Play F chord again (second time)
        play_note(G4, 500);  // Play G chord again (first time)
        play_note(G4, 500);  // Play G chord again (second time)
        play_note(C4, 500);  // Play C chord (first time)
        play_note(C4, 500);  // Play C chord (second time)
        */ 
        
        // Play the first phrase of the Game of Thrones theme
        play_note(G4, 500);  // G4
        play_note(C5, 500);  // C5
        play_note(Eb5, 500);  // Eb5
        play_note(G5, 500);  // G5
        play_note(F5, 500);  // F5
        play_note(D5, 500);  // D5
        play_note(Bb4, 500);  // Bb4
        play_note(G4, 500);  // G4

        // Short pause between phrases
        delay_ms(500);

        // Repeat the phrase
        play_note(G4, 500);  // G4
        play_note(C5, 500);  // C5
        play_note(Eb5, 500);  // Eb5
        play_note(G5, 500);  // G5
        play_note(F5, 500);  // F5
        play_note(D5, 500);  // D5
        play_note(Bb4, 500);  // Bb4
        play_note(G4, 500);  // G4
        
        break;
    }       
}
