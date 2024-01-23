LIST P=12F683 ; Lista de comandos para el PIC12F683
#include <p12F683.inc> ; Archivo de definiciones del PIC

__CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF

VOLT		EQU 0X20
THRESHOLD	EQU 0X21

ORG 0X00
MOVLW	3
MOVWF	THRESHOLD

;CONFIGURACIONES INICIALES
BCF		STATUS,RP0
CLRF	GPIO
MOVLW	0X07					;Comparador apagado
MOVWF	CMCON0
MOVLW	b'10000001'				;ADFM justificado a la derecha, voltaje de referencia en VDD,
MOVWF	ADCON0					;AN0 seleccionado y modulo de ADC activo.
BSF		STATUS,RP0
MOVLW	b'00000001'				;Bit 0 configurado como analogo, los demas digitales.
MOVWF	ANSEL		
MOVLW	b'00010001'				;GPIO 3 y 4 como entrada, el resto como salidas.
MOVWF	TRISIO
MOVLW	b'01100000'				;OSCCON configurado a 4MHz
MOVFW	OSCCON
MOVLW	0X40
MOVWF	PIR1					;Bandera de interrupcion para el ADC.
MOVLW	0x00
MOVWF	INTCON					;Activar interrupciones globales.
BCF		STATUS,RP0

;Bucle principal
Switch_on      		BTFSS	GPIO, 	4
            		GOTO 	Switch_on
            		GOTO	ON

;Revision de tensión
Switch_off			BTFSC	GPIO,	4
					GOTO	V_check
					GOTO	OFF
V_check				MOVLW	0x83				;Lee AN0 y se guarda en la variable VOLT.
					MOVWF	ADCON0
goback				BTFSS	PIR1,	6
					GOTO	goback
					BCF		PIR1,	6
					MOVF	ADRESL,	0
					MOVWF	VOLT
					MOVF	THRESHOLD,	0		
					SUBWF	VOLT,0				;Realiza la resta de entre VOLT y THRESHOLD (VOLT - THRESHOLD)
					BTFSC	STATUS,C			;Verificar si la resta produce Borrow
					GOTO	ON					;Corriente menor al umbral
					GOTO	OFF					;Corriente mayor al umbral	
					
;ON/OFF
ON					BSF		GPIO,	5			;Encender motor
					GOTO	Switch_off
OFF					BCF		GPIO, 	5			;Apagar motor del molino por sobrevoltaje o por fin de operación
					GOTO	Switch_on

END