
;######################### P13 Settings #############################################
P13_SETTINGS_START:
;--- Interrupts ---
;int_NO0				EQU 	int_ToggleBit
;int_NO1 				EQU		int_ToggleBit
;int_NO2 				EQU		int_ToggleBit
;int_NO3 				EQU		int_ToggleBit
;int_NO4 				EQU		int_ToggleBit
;int_NO5 				EQU		int_ToggleBit
;int_NO6 				EQU		int_ToggleBit
;int_NO7 				EQU		int_ToggleBit
;int_NO8 				EQU		int_ToggleBit
;int_NO9 				EQU		int_ToggleBit
;int_NO10				EQU		int_ToggleBit
;int_NO11				EQU		int_ToggleBit
int_NO12				EQU		int_serial_RX			; Override standard interrupt and use handler instead
;int_NO13				EQU		int_ToggleBit
;int_NO14				EQU		int_ToggleBit
;int_NO15				EQU		int_ToggleBit
int_WDT					EQU		BIOS_START
int_start				EQU		BIOS_START
int_break				EQU		BIOS_START
int_NMI					EQU 	BIOS_START
int_unexpected			EQU		BIOS_START

;--- System ---
STACK_START				EQU		047FH					; Address to init stack
IE_INIT					EQU		01000H					; default IE (01000H FOR SERIAL ONLY, 0FFEFh to exclude 1 timer int)
LRB_INIT				EQU		00020h					; Default LRB
PSW_INIT				EQU 	00102H					; Default PSW to set MIE, and SCB
USP_INIT 				EQU 	00180H					; Default USP

;--- Port Settings ---
PORT_2_SF               EQU     026h
PORT_2_SF_SET           EQU     006h
PORT_2_IO               EQU     027h
PORT_2_IO_SET           EQU     006h
PORT_2                  EQU     028h
PORT_2_SET              EQU     0f0h
PORT_2A                 EQU     025h
PORT_2A_SET             EQU     06fh
PORT_3_SF               EQU     022h
PORT_3_SF_SET           EQU     0f0h
PORT_3_IO               EQU     023h
PORT_3_IO_SET           EQU     0ffh
PORT_3                  EQU     024h
PORT_3_SET              EQU     007h
PORT_4_SF               EQU     01fh
PORT_4_SF_SET           EQU     011h
PORT_4_IO               EQU     020h
PORT_4_IO_SET           EQU     011h
PORT_4                  EQU     021h
PORT_4_SET              EQU     011h

;--- Serial ---
SERIAL_DELAY			EQU		000FFh					; Delay value to wait before sending another byte
SERIAL_STBUF            EQU     07ch 					; Transmit buffer
SERIAL_SRBUF            EQU     07dh 					; Receive buffer
SERIAL_STTMR    		EQU     078h  					; Serial baud address 1
SERIAL_STTM    		    EQU     079h  					; Serial baud address 2
SERIAL_BAUD_SET		    EQU		007H					; Baud rate reload value
SERIAL_STCON       		EQU		07AH					; STCON
SERIAL_STCON_SET       	EQU		080H					; STCON init setting
SERIAL_SRCON       		EQU		07BH					; SRCON
SERIAL_SRCON_SET	    EQU		080H					; SRCON init setting
SERIAL_SRSTAT      		EQU		07EH					; SRSTAT (STTMC??)
SERIAL_SRSTAT_SET	    EQU		020H					; SRSTAT init setting
SERIAL_STTMC       		EQU		0ffh
SERIAL_STTMC_VAL	    EQU		0ffh

;--- Timers ---
PCLOCK_REG				EQU 	00fh					; Main clock setting register that affects PWM and others
PCLOCK_INIT				EQU 	0a4h					; Default settings for PCLCOK
TIMER_44_TO_52_CON0     EQU     042h
TIMER_44_TO_52_CON0_SET EQU     0f0h
TIMER_44_TO_52_CON1     EQU     043h
TIMER_44_TO_52_CON1_SET EQU     000h
TIMER_56_CON0           EQU     054h
TIMER_56_CON0_SET       EQU     089h
TIMER_56_CON1           EQU     055h
TIMER_56_CON1_SET       EQU     000h
TIMER_62_TO_64_CON      EQU     061h
TIMER_62_TO_64_CON_SET  EQU     010h

;--- Asic Feeder ---
ASICPORT_OUT    		EQU	    025H					; Port address with asic feeder pin
ASICPIN					EQU	    002h 					; ASIC feeder pin on 7u016 or whatever the chip is

;--- Free IO to use for feedback ---
TOGGLE_PORT				EQU 	025h					; Port to use during interrupts to toggle pin
TOGGLE_BIT				EQU		004h					; Bit Mask of pin to toggle

;--- 82c55 Settings ---
IO_CHIP_CON				EQU		0E000H					; 82c55 controll register 
IO_CHIP_SET				EQU		090H					; 82c55 control register init setting
IO_CHIP_A				EQU		08000H					; 82c55 Port A address
IO_CHIP_B				EQU		0A000H					; 82c55 Port B address
IO_CHIP_B_SET			EQU		0F7H					; 82c55 Port B init setting
IO_CHIP_C				EQU		0C000H					; 82c55 Port C address
IO_CHIP_C_SET			EQU		0FFH					; 82c55 Port C init setting

;--- ADC ---
ADSCAN_VAL				EQU		010h
ADSEL_VAL				EQU		000h

;--- PWM ---
PWMSF_REG				EQU 	01fh					; PWM Port Special function register
PWMIO_REG				EQU 	020h 					; PWM IO Register
PWMPORT					EQU		021h					; Port for PWM outputs
PWMPORT_INIT			EQU		011h					; Default value for PWMPORT
PWM_PRESCALER_REG		EQU		02dh					; PWM prescaler register location
PWM_PRESCALER_VAL		EQU		093h					; PWM Presacaler value
PWM0_CON_REG			EQU		02ah					; PWM 0 Control register
PWM0_CON_VAL			EQU		003h					; Default value for PWM 0 Control register 		
PWM1_CON_REG			EQU		02ch					; PWM 1 Control register
PWM1_CON_VAL			EQU		06fh					; Default value for PWM 1 Control register
PWM0_REGISTER			EQU		02eh					; PWM Register (duty) 
PWM0_REGISTER_VAL		EQU		00001h					; Default PWM Register (duty) value
PWM1_REGISTER			EQU		03eh					; PWM Register (duty)
PWM1_REGISTER_VAL		EQU		09ff6h					; Default PWM Register (duty) value

P13_SETTINGS_END:
