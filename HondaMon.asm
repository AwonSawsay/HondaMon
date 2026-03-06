ECU_IS_P13 EQU 1               							; 1 for 66911 Based ECU, 0 for 66207 based ECU                                                                                                               

#if ECU_IS_P13
	include "P13_Settings_Custom.asm"					; MCU Settings for 66911 ECU
#else
	include "P28_Settings_Custom.asm" 					; MCU Settings for 66207 ECU
#endif  

org 0000h
include "VtableAndInterrupts.asm"						; Import the Vector table and all Interrupt functions
include "BIOS.asm"										; Setup the MCU and accessories

org WOZMON_LOC											; Import WozMon, at it's location below
	include "WozMon.asm"                                                              

org BIOS_END											; Set code pointer to start the following after the BIOS.asm file

;--------------------- DASM Helper -------------------------
; Use this area to create references to code areas not being dasm'd due to manual or obscure calling
                CLRB 	A
				JEQ 	$ + 5
				J 		WOZMON_START
				;JEQ 	$ + 5
				;J 		NEXT_CODE_TO_REFERENCE_HERE
DBHReturn: 
				
;---------------------------- Test Code Area -------------------------------------------

; Use this area to test code, before loading wozmon.
; Assign an address to the test code with "org" and then re run the code from 
; WozMon by using adressR
         

;################################ WozMon #######################################
WOZMON_LOC:												; WozMon Code begins here
org WOZMON_END											; WozMon Code ends here
;###############################################################################






				