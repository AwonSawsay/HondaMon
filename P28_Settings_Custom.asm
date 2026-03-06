
;######################### P28 Stock Settings #############################################
P28_SETTINGS_START:
;--- Interrupts ---
;int_NO0				EQU 	int_ToggleBit
int_NO1					EQU 	int_serial_RX			; Override standard interrupt and use handler instead					
;int_NO2				EQU 	int_serial_TX
;int_NO3 				EQU		int_ToggleBit
;int_NO4 				EQU		int_ToggleBit
;int_NO5 				EQU		int_ToggleBit
;int_NO6 				EQU		int_ToggleBit
;int_NO7 				EQU		int_ToggleBit
;int_NO8 				EQU		int_ToggleBit
;int_NO9 				EQU		int_ToggleBit
;int_NO10				EQU		int_ToggleBit
;int_NO11				EQU		int_ToggleBit
;int_NO12				EQU		int_ToggleBit
;int_NO13				EQU		int_ToggleBit
;int_NO14				EQU		int_ToggleBit
;int_NO15				EQU		int_ToggleBit
int_WDT					EQU		BIOS_START
int_start				EQU		BIOS_START
int_break				EQU		BIOS_START
int_NMI					EQU 	BIOS_START
;int_unexpected			EQU		int_ToggleBit

;--- System ---
STACK_START				EQU		047EH					; Address to init stack
IE_INIT					EQU		00002H					; Can be  0x02a0 0x2bab 0x00a0 0xa9a3
LRB_INIT				EQU		00020h					; Default LRB
PSW_INIT				EQU 	00102H					; Default PSW to set MIE, and SCB
USP_INIT 				EQU 	00180H					; Default USP

;--- Port Settings ---
PORT_0_IO               EQU     021h
PORT_0_IO_SET           EQU     0ffh
PORT_0                  EQU     020h
PORT_0_SET              EQU     0ebh
PORT_1_IO               EQU     023h
PORT_1_IO_SET           EQU     0ffh
PORT_1                  EQU     022h
PORT_1_SET              EQU     044h

PORT_2_SF               EQU     026h
PORT_2_SF_SET           EQU     000h
PORT_2_IO               EQU     025h
PORT_2_IO_SET           EQU     0ffh
PORT_2                  EQU     024h
PORT_2_SET              EQU     00fh
PORT_3_SF               EQU     02ah
PORT_3_SF_SET           EQU     0ffh
PORT_3_IO               EQU     029h
PORT_3_IO_SET           EQU     0b1h
PORT_3                  EQU     028h
PORT_3_SET              EQU     0efh
PORT_4_SF               EQU     02eh
PORT_4_SF_SET           EQU     0f0h
PORT_4_IO               EQU     02dh
PORT_4_IO_SET           EQU     00dh
PORT_4                  EQU     02ch
PORT_4_SET              EQU     0f6h

;--- Serial ---
SERIAL_DELAY			EQU		000FFh					; Delay value to wait before sending another byte
SERIAL_STBUF  		    EQU     051h 					; Transmit buffer
SERIAL_SRBUF   	    	EQU     055h 					; Receive buffer
SERIAL_STTMR    		EQU     048h  					; STTM
SERIAL_STTM    		    EQU     049h  					; STTMR
SERIAL_BAUD_SET			EQU		0F8H					; Baud rate reload value
SERIAL_STCON			EQU		050H					; STCON
SERIAL_STCON_SET 		EQU		01cH					; STCON init setting
SERIAL_SRCON			EQU		054H					; SRCON
SERIAL_SRCON_SET		EQU		08cH					; SRCON init setting
SERIAL_SRSTAT			EQU		056H					; SRSTAT (STTMC??)
SERIAL_SRSTAT_SET		EQU		000H					; SRSTAT init setting
SERIAL_STTMC			EQU		04ah
SERIAL_STTMC_VAL		EQU		012h
;--- Asic Feeder ---
ASICPORT_OUT    		EQU	    024H					; Port address with asic feeder pin
ASICPIN					EQU	    010h 					; ASIC feeder pin on 7u016 or whatever the chip is

;--- Free IO to use for feedback ---
TOGGLE_PORT				EQU 	02ch					; Port to use during interrupts to toggle pin
TOGGLE_BIT				EQU		004h					; Bit Mask of pin to toggle

;--- 82c55 Settings ---
IO_CHIP_CON				EQU		03f00H					; 82c55 controll register 
IO_CHIP_SET				EQU		090H					; 82c55 control register init setting
IO_CHIP_A				EQU		00f00H					; 82c55 Port A address
IO_CHIP_B				EQU		01f00H					; 82c55 Port B address
;IO_CHIP_B_SET			EQU		0ebH					; 82c55 Port B init setting
IO_CHIP_B_SET			EQU		000H					; 82c55 Port B init setting
IO_CHIP_C				EQU		02f00H					; 82c55 Port C address
IO_CHIP_C_SET			EQU		044H					; 82c55 Port C init setting

;--- ADC ---
ADSCAN_VAL				EQU		010h
ADSEL_VAL				EQU		000h

;--- PWM ---
PWM0_CON_REG			EQU		078h					; PWM 0 Control register
PWM0_CON_VAL			EQU		03eh					; Default value for PWM 0 Control register 		
PWM1_CON_REG			EQU		07ah					; PWM 1 Control register
PWM1_CON_VAL			EQU		07eh					; Default value for PWM 1 Control register
PWM0_REGISTER			EQU		072h					; PWM Register (duty) 
PWM0_REGISTER_VAL		EQU		0ff00h					; Default PWM Register (duty) value
PWM1_REGISTER			EQU		076h					; PWM Register (duty)
PWM1_REGISTER_VAL		EQU		0ff00h					; Default PWM Register (duty) value

;--- Timers ---
TIMER0					EQU 	030h	
TIMER0_VAL				EQU 	00000h
TM0_REG					EQU 	032h
TM0_REG_VAL				EQU		00000h
TIMER1					EQU		034h	
TIMER1_VAL				EQU 	00000h
TM1_REG					EQU 	036h
TM1_REG_VAL				EQU		00000h
TIMER2					EQU		038h
TIMER2_VAL				EQU 	00000h
TM2_REG					EQU		03ah
TM2_REG_VAL				EQU		00001h
TIMER3					EQU		03ch
TIMER3_VAL				EQU 	00000h
TM3_REG					EQU		03eh
TM3_REG_VAL				EQU 	00000h
TM0_CON					EQU		040h
TM0_CON_VAL				EQU		08bh
TM1_CON					EQU 	041h
TM1_CON_VAL				EQU		04fh
TM2_CON					EQU		042h
TM2_CON_VAL				EQU		082h
TM3_CON					EQU		043h
TM3_CON_VAL				EQU		08fh

P28_SETTINGS_END:
