;####################### Startup #######################################################

BIOS_START:
				
                MOV     SSP, #STACK_START       	; Set Stack space
				MOV     LRB, #LRB_INIT          	; Set Local Register base 
				MOV     USP, #USP_INIT            	; Set USP
				MOV     IE, #IE_INIT            	; Set active Interrupts
				MOV     PSW, #PSW_INIT            	; Enable active interrupts and set page
                CAL     SetupASIC
                CAL 	SetupPorts
                CAL 	SetupSerial
				CAL 	SetupTimers
                CAL 	SetupPWM
                CAL		Setup82c55
				CAL 	SetupRAM
                J		BIOS_END

;#######################################################################################
SetupASIC:
                MOV     X1, #000FFh
KeepLooping:
                DEC     X1
                JNE     KeepLooping  
                XORB    ASICPORT_OUT, #ASICPIN


;-------------------------Ports Setup --------------------------------------------
SetupPorts:
				MOVB	PORT_2_SF, #PORT_2_SF_SET 
				MOVB	PORT_2_IO, #PORT_2_IO_SET 
				MOVB	PORT_2, #PORT_2_SET    
				MOVB	PORT_3_SF, #PORT_3_SF_SET
				MOVB	PORT_3_IO, #PORT_3_IO_SET
				MOVB	PORT_3, #PORT_3_SET
				MOVB	PORT_4_SF, #PORT_4_SF_SET 
				MOVB	PORT_4_IO, #PORT_4_IO_SET
				MOVB	PORT_4, #PORT_4_SET

#if ECU_IS_P13 == 1
; P13 only
				MOVB	PORT_2A, #PORT_2A_SET
#else
; P28 Settings
                MOVB    PORT_0_IO, #PORT_0_IO_SET
                MOVB    PORT_0, #PORT_0_SET
                MOVB    PORT_1_IO, #PORT_1_IO_SET
                MOVB    PORT_1, #PORT_1_SET
#endif
                RT

;-------------------------Serial Setup -------------------------------------------
SetupSerial:
				LB      A, #SERIAL_BAUD_SET               	; 8-N-1, 39063 baud.
                STB     A, SERIAL_STTM
                STB     A, SERIAL_STTMR
				MOVB    SERIAL_STCON, #SERIAL_STCON_SET
                MOVB    SERIAL_SRCON, #SERIAL_SRCON_SET
                MOVB    SERIAL_SRSTAT, #SERIAL_SRSTAT_SET
				MOVB 	SERIAL_STTMC, #SERIAL_STTMC_VAL
				RT
;----------------------- PWM SETUP ------------------------------------------------
SetupPWM:
#if ECU_IS_P13 == 1
				MOVB 	PWM_PRESCALER_REG, #PWM_PRESCALER_VAL		; Set Prescaler
#endif
				MOVB 	PWM0_CON_REG, #PWM0_CON_VAL					; Set PWM0 control register
				MOVB 	PWM1_CON_REG, #PWM1_CON_VAL					; Set PWM1 control register
				MOV 	PWM0_REGISTER, #PWM0_REGISTER_VAL			; Set PWM 0 register
				MOV 	PWM1_REGISTER, #PWM1_REGISTER_VAL			; Set PWM 1 register
				RT	
;----------------------------- 82c55 Setup ---------------------------------------------
Setup82c55:
                MOV     DP, #IO_CHIP_CON             
                LB      A, #IO_CHIP_SET             ; Set 82c55 mode 0.  A = input B,C = outputs 
                STB     A, [DP]
				MOV 	DP, #IO_CHIP_B
				LB      A, #IO_CHIP_B_SET	   	; turn off all port B accessories
				STB     A, [DP]
                MOV 	DP, #IO_CHIP_C
				LB      A, #IO_CHIP_C_SET	   	; Turn off all port C accessories	
				STB     A, [DP]
                RT
;----------------------- P28 Timers ----------------------------------------------------

SetupTimers:
#if ECU_IS_P13 == 1 
; P13 Settings                
                MOVB    PCLOCK_REG, #PCLOCK_INIT
                MOVB    TIMER_44_TO_52_CON0, #TIMER_44_TO_52_CON0_SET
                MOVB    TIMER_44_TO_52_CON1, #TIMER_44_TO_52_CON1_SET
                MOVB    TIMER_56_CON0, #TIMER_56_CON0_SET
                MOVB    TIMER_56_CON1, #TIMER_56_CON1_SET
                MOVB    TIMER_62_TO_64_CON, #TIMER_62_TO_64_CON_SET
; P28 Settings
#else                
				MOV		TIMER0, #TIMER0_VAL	
				MOV		TM0_REG, #TM0_REG_VAL
				MOV		TIMER1, #TIMER1_VAL	
				MOV		TM1_REG, #TM1_REG_VAL
				MOV		TIMER2, #TIMER2_VAL	
				MOV		TM2_REG, #TM2_REG_VAL
				MOV		TIMER3, #TIMER3_VAL	
				MOV		TM3_REG, #TM3_REG_VAL
				
				MOVB    TM0_CON, #TM0_CON_VAL
				MOVB    TM1_CON, #TM1_CON_VAL
				MOVB    TM2_CON, #TM2_CON_VAL
				MOVB    TM3_CON, #TM3_CON_VAL
				
				ORB     TM0_CON, #010h
				ORB     TM1_CON, #010h
				ORB     TM2_CON, #010h
				ORB     TM3_CON, #010h
#endif	
                RT
;----------------------- Clear RAM----------------------------------------------
			

SetupRAM:       
        		CLR 	A
				MOV 	DP, #((PSW_INIT & 0xff) + 1) * 8 + 0x80	; Address to start clearing RAM (after PR registers)
			
clearRam:		
				ST		A, [DP]
				INC 	DP
				INC 	DP
				CMP 	DP, #STACK_START - 4					; Don't clear the RT addresses off the stack

				JLE 	clearRam
				RT				
BIOS_END:
				