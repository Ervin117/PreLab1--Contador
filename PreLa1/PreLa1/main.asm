;
; PreLa1.asm
;
; Created: 2/2/2025 10:33:44 PM
; Author : Ervin Gomez 231226
;

//Configurara el ATmega328P
.include "m328Pdef.inc"

.cseg
.org	0x0000
//Configuración de la pila 
LDI		R16, LOW(RAMEND)
OUT		SPL, R16
LDI		R16, HIGH(RAMEND)
OUT		SPH, R16

//Configuracion de inicio 
SETUP: 
	//Configuracion de los pines de entrad y salida
	LDI		R16, 0x0F
	OUT		DDRB, R16 //PORTB como salida
	LDI		R16, 0x0F
	OUT		DDRC, R16 //PORTC como salida
	LDI		R16, 0x00
	OUT		DDRD, R16 //PORTD como entrada
	LDI		R16, 0x0C
	CLR		R17
	OUT		PORTB, R17 //Inicio del contador en 0 

MAIN: 
	//Loop infinito
	SBIC	PIND, PD2 //Verifica el estado del boton 1
	RJMP	INCREMENT //Llama la rutina de incremento
	SBIC	PIND, PD3 //Verifica el estado del boton 2
	RJMP	DECREMENT //Llama la rutina de decremento
	SBIC	PIND, PD4 //Verifica el estado del boton 3
	RJMP	INCREMENT2 //Llama la rutina de incremento
	SBIC	PIND, PD5 //Verifica el estado del boton 4
	RJMP	DECREMENT2 //Llama la rutina de decremento
	RJMP	MAIN //Regresa al loop

INCREMENT: 
	//Logica de incremento 
	CPI		R17, 0x0F //Para el incremento al llegar al valor 0x0F
	BREQ	MAIN
	INC		R17		  //Incrementa el contador 
	OUT		PORTB, R17 //Actualiza la salida
	RJMP	RETARDO

DECREMENT:
	//Logica de decremento
	CPI		R17, 0x00 //Para el contador si es 0x00
	BREQ	MAIN
	DEC		R17		  //Decrementar el contador 
	OUT		PORTB, R17 //Actualiza salida
	RJMP	RETARDO

//Logica Antirebotes
RETARDO: 
	LDI		R18, 0xFF //Cargar valor para retardo 

DELAY: 
	DEC		R18
	BRNE	DELAY 
	RJMP	MAIN
