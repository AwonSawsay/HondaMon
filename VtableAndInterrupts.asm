;############### Vector Table #######################################################
                org 0000h
int_start_vec:            DW  int_start        	; 
int_break_vec:            DW  int_break        	; 
int_WDT_vec:              DW  int_WDT   		; 
int_NMI_vec:              DW  int_NMI          	; 
;---- Maskable Interrupts                        
int_INT0_vec:             DW  int_NO0 			; IE/IRQ Bit  0 ###
int_serial_rx_vec:        DW  int_NO1 			; IE/IRQ Bit  1 ###
int_serial_tx_vec:        DW  int_NO2 			; IE/IRQ Bit  2 ###
int_serial_rx_BRG_vec:    DW  int_NO3 			; IE/IRQ Bit  3 ###
int_timer_0_overflow_vec: DW  int_NO4 			; IE/IRQ Bit  4 ### 
int_timer_0_vec:          DW  int_NO5 			; IE/IRQ Bit  5 ###
int_timer_1_overflow_vec: DW  int_NO6 			; IE/IRQ Bit  6 ###
int_timer_1_vec:          DW  int_NO7 			; IE/IRQ Bit  7 ###
int_timer_2_overflow_vec: DW  int_NO8 			; IE/IRQ Bit  8 ###
int_timer_2_vec:          DW  int_NO9 			; IE/IRQ Bit  9 ###
int_timer_3_overflow_vec: DW  int_NO10			; IE/IRQ Bit 10 ### 
int_serial_tx_vec:        DW  int_NO11			; IE/IRQ Bit 11 ###
int_serial_RX_vec:        DW  int_NO12			; IE/IRQ Bit 12 ###
int_PWM_timer_vec:        DW  int_NO13			; IE/IRQ Bit 13 ###  
int_serial_tx_BRG_vec:    DW  int_NO14			; IE/IRQ Bit 14 ###
int_INT1_vec:             DW  int_NO15			; IE/IRQ Bit 15 ###

;---- Vector Calls
vcal_0_vec:               DW  dummyVCAL		   	; 
vcal_1_vec:               DW  dummyVCAL		   	; 
vcal_2_vec:               DW  dummyVCAL		   	; 
vcal_3_vec:               DW  dummyVCAL		   	; 
vcal_4_vec:               DW  dummyVCAL		   	; 
vcal_5_vec:               DW  dummyVCAL		   	; 
vcal_6_vec:               DW  dummyVCAL		   	; 
vcal_7_vec:               DW  dummyVCAL		   	; 

;----------------------- Interrupts ----------------------------------------------------
; 18.0 1A.0
int_NO0:		
				LB 		A, #030h
				CAL 	ISR_SendChar 
				RTI          
; 18.1 1A.1
											
int_NO1:		             
				LB 		A, #031h
				CAL 	ISR_SendChar 
				RTI          
; 18.2 1A.2
int_NO2:		             
				LB 		A, #032h
				CAL 	ISR_SendChar 
				RTI          
; 18.3 1A.3
int_NO3:		             
				LB 		A, #033h
				CAL 	ISR_SendChar 
				RTI          
; 1A.4 18.4
int_NO4:		             
				LB 		A, #034h
				CAL 	ISR_SendChar 
				RTI          
; 18.5 1A.5
int_NO5:		             
				LB 		A, #035h
				CAL 	ISR_SendChar 
				RTI          
; 18.6 1A.6
int_NO6:
				LB 		A, #036h
				CAL 	ISR_SendChar 
				RTI          
; 18.7 1A.7
int_NO7:		             
				LB 		A, #037h
				CAL 	ISR_SendChar 
				RTI          				
											
; 19.0 1B.0
int_NO8:		             
				LB 		A, #038h
				CAL 	ISR_SendChar 
				RTI          

; 19.1 1B.1
int_NO9:		             				
				LB 		A, #039h
				CAL 	ISR_SendChar
				RTI
; 19.2 1B.2
int_NO10:		
				LB 		A, #041h
				CAL 	ISR_SendChar
				RTI
; 19.3 1B.3
int_NO11:
				LB 		A, #042h
				CAL 	ISR_SendChar
				RTI

; 19.4 1B.4
int_NO12:
				LB 		A, #043h
				CAL 	ISR_SendChar
				RTI
; 19.5 1B.5
int_NO13:
				LB 		A, #044h
				CAL 	ISR_SendChar
				RTI
; 19.6 1B.6
int_NO14:		
				LB 		A, #045h
				CAL 	ISR_SendChar
				RTI
; 19.7 1B.7
int_NO15:
				LB 		A, #046h
				CAL 	ISR_SendChar
				RTI

int_unexpected: RTI

dummyVCAL:
				RT

;-- Serial RX Handler for wozmon
int_serial_RX:
				CLR 	A 
				LB 		A, r1
				MOV 	X1, A
				LB 		A, SERIAL_SRBUF
				CMPB	A, #01bh				; 'ESC'?
				JNE 	BufferRXData			; Not 'ESC'
				CAL		SetupSerial				; Got 'ESC', re-init serial
				ADD 	SSP, #00008h			; Point to RTI return address
				L	 	A, #WOZMON_START		; Get wozmon start
				PUSHS 	A						; Push wozmon start to RTI return address
				SUB 	SSP, #00006h			; Fix stack pointer
				RTI								; Exit Interrupt
BufferRXData:				
				STB 	A, INPUT_BUFFER[X1]		; RX data to buffer
				INCB 	r1						; Inc buffer pointer
				RTI								; Exit Interrupt



;-------- Toggle I/O Bit  --------------------
int_ToggleBit: 	
				XORB 	TOGGLE_PORT, #TOGGLE_BIT
				RTI

; --- Send A on serial ---
ISR_SendChar:
				STB 	A, SERIAL_STBUF
				RT