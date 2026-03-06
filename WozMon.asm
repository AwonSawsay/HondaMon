; OKI 66k WozMon Port 
; A port of Woz Monitor for the Apple II , to run on Honda OBD I ECUs

VERSION_MAJOR	EQU 	1
VERSION_MINOR	EQU 	1

;
; Usage:
;	Address 					-	Get byte value at address
;	Address1 Address2 etc		-	Get bytes from multiple addresses
;	AddressLow.AddressHigh		-	Get all data between addresses
;	Address:Data				-	Set byte at address
; 	Address:Data1 Data 2 etc	- 	Set bytes, starting at address
;	Address-DataWord			-	Set word at address
;	ROMAddressR (eg 300R)		-	Execute code at ROM address			
;
; Requirements:
;	Full duplex communcication on the ECU at 38400 baud, and the following serial RX code enabled
;
; -----------------------------------------
;int_serial_RX:
;				CLR 	A 
;				LB 		A, r1
;				MOV 	X1, A
;				LB 		A, SERIAL_DATAIN
;				CMPB	A, #01bh				; 'ESC'?
;				JNE 	BufferRXData			; Not 'ESC'
;				CAL		SetupSerial				; Got 'ESC', re-init serial
;				ADD 	SSP, #00008h			; Point to RTI return address
;				L	 	A, #WOZMON_START		; Get wozmon start
;				PUSHS 	A						; Push wozmon start to RTI return address
;				SUB 	SSP, #00006h			; Fix stack pointer
;				RTI								; Exit Interrupt
;BufferRXData:				
;				STB 	A, INPUT_BUFFER[X1]		; RX data to buffer
;				INCB 	r1						; Inc buffer pointer
;				RTI								; Exit Interrupt
; -----------------------------------------
;

;################# WozMon Settings ###############################################
WOZ_RAM_START	EQU		00108H
BUFFER_START	EQU		00300H		

;--- WozMon ---								
XAML            		EQU     WOZ_RAM_START			; Last "opened" location Low
XAMH            		EQU     XAML+1					; Last "opened" location High
STL             		EQU     XAMH+1					; Store address Low
STH             		EQU     STL+1					; Store address High
HEX_LOW         		EQU     STH+1					; Hex value parsing Low
HEX_HIGH        		EQU     HEX_LOW+1				; Hex value parsing High
MODE            		EQU     HEX_HIGH+1				; $00=XAM, $7F=STOR, $AE=BLOCK XAM
SERIAL_STATUS   		EQU     MODE+1					
INPUT_BUFFER    		EQU     BUFFER_START			; Input buffer
;r0             		EQU 	      					; Processing Buffer index
;r1             		EQU           					; Serial Interrupt buffer index
;r2             		EQU           					; 
;r3             		EQU           					; YSAV register 
;r4             		EQU           					;                                       
;r5             		EQU           					; 
;r6             		EQU           					; 
;r7             		EQU           					; Serial Delay Counter
;DP 					EQU           					; Used for delays and XAM lookup and Store command
;X1             		EQU           					; Lookup index for serial buffer
;X2             		EQU   							; Serial Delay counter

   
;------------------------ Woz Mon Begin -------------------------------------------
WOZMON_START:

WozMon:
				CLR 	er0
				CLR 	er1
				CLR 	er2
				CLRB    off(MODE)
				LB      A, #01bh               	; Begin with escape.
NOTCR:	
                CMPB    A, #008h               	; Backspace key?
                JEQ     BACKSPACE              	; Yes.
                CMPB    A, #01Bh               	; ESC?
                JEQ     ESCAPE                 	; Yes.
				INCB 	r0                     	; Advance text index.
				RB 		r0.7                   	; Auto ESC if line longer than 127.
				JEQ 	NEXTCHAR	
																
ESCAPE:			                               	
                ;LB      A, #05Ch               	; "\".
				LB 		A, #00dh				; Carriage return
				CAL     ECHO                   	; Output it.
				LB      A, #00ah               	; NL
                CAL     ECHO                   	; Output it.
				MOV 	X1, #WZS_terminal		; Send Wozmon terminal string
				CAL 	Woz_sendString

GETLINE:                                       	
                LB      A, #00dh               	; Send CR
                CAL     ECHO                   	
				LB      A, #00ah               	; NL
                CAL     ECHO                   	; Output it.				
				MOVB 	r1, #002h              	; Reset serial interrupt index
BACKSPACE:     	
				DECB 	r0                     	; Back up text index.
				RB   	r0.7                   	; Beyond start of line, reinitialize.
				JNE 	GETLINE
				DECB 	r1
				DECB 	r1
				MOVB 	r0, r1
				JBR 	off(MODE).5, NEXTCHAR  	; Used to return to our 'Extras' program
				RT						       
;--- Waiting Loop
NEXTCHAR:                                      
				
				CAL 	WDT_feeder             	; Service ASIC WDT
				CLR 	A
				LB 		A, r0	
				CMPB 	A, r1                  	; Is there unprocessed data in the input buffer?
				JEQ 	NEXTCHAR               	; No new data, keep checking
;---
				MOV 	X1, A	
				LB  	A, INPUT_BUFFER[X1]    	; Get new byte from the buffer
				CAL     ECHO                   	; Display character.

CHECK_CR:
				CMPB    A, #00Dh               	; CR?
                JNE     NOTCR                  	; No.
				MOVB 	r0, #0ffh            	; Reset text index.
				CLRB 	r1
				CLRB     A                     	; For XAM mode.
				 		
				
SETBLOCK:
                SLLB    A
SETSTOR:
                SLLB    A                      	; Leaves $7B if setting STOR mode.
                ANDB 	A, #0C0h               	; Bit mask to keep upper 2 bits only
SETMODE:
				STB     A, off(MODE)           	; $00 = XAM, $74 = STOR, $B8 = BLOK XAM.
BLSKIP:	
				INCB 	r0                     	; Advance text index.
NEXTITEM:	
				CLR		A	
				LB		A, r0	
				MOV 	X1, A					; bffer index to x1	
				LB      A, INPUT_BUFFER[X1]    	; Get character.
					
				CMPB    A, #00Dh               	; CR?
                JEQ     GETLINE                	; Yes, done this line.
                CMPB    A, #02Eh               	; "."?
                JEQ     SETBLOCK               	; Set BLOCK XAM mode.
				CMPB 	A, #02dh				; "-" ?
				JNE 	CHECKNEXT				; No, Check what else it can be
				LB 		A, #041h				; Yes, Set the Store and word flags
				SJ 		SETMODE					; Set the mode
CHECKNEXT:
				JLT     BLSKIP                 	; Skip delimiter.

                CMPB    A, #03Ah               	; ":"?
                JEQ     SETSTOR                	; Yes, set STOR mode.
                CMPB    A, #052h               	; "R"?
                JEQ     RUN                    	; Yes, run user program.
				CLRB 	A	
				STB     A, off(HEX_LOW)        	; $00 -> HEX_LOW.
                STB     A, off(HEX_HIGH)       	;    and H.
				MOVB 	r3, r0                 	; Save index for comparison
  

;Parse hex digits
NEXTHEX:
				CLR 	A
				LB 		A, r0
				MOV 	X1, A					; Buffer index to X1
				LB      A, INPUT_BUFFER[X1]    	; Get character for hex test.
                XORB    A, #030h               	; Map digits to $0-9.
                CMPB    A, #00Ah               	; Digit?
                JLT     DIG                    	; Yes.
;Letter parsing	
                ADDB    A, #089h               	; Map letter "A"-"F" to $FA-FF.
                CMPB    A, #0FAh               	; Hex letter?
                JLT     NOTHEX                 	; No, character not hex.
;Number Parsing	
DIG:	
                SLLB    A	
                SLLB    A                      	; Hex digit to MSD of A.
                SLLB    A	
                SLLB    A	
	
                MOVB    r2, #004h              	; Shift count.
;Shift new digits into memory, keeping up to 4 digits, shifting out the oldest digit
HEXSHIFT:
                SLLB    A                      	; Hex digit left, MSB to carry.
                ROLB    off(HEX_LOW)           	; Rotate into LSD.
                ROLB    off(HEX_HIGH)          	; Rotate into MSD's.
                DECB    r2                     	; Done 4 shifts?
                JNE     HEXSHIFT               	; No, loop.
				INCB 	r0                     	; Advance text index.
				SJ      NEXTHEX                	; Always taken. Check next character for hex.
	
;Invalid character	
NOTHEX:	
				LB 		A, r3
				CMPB 	A, r0                  	; Check if HEX_LOW, HEX_HIGH empty (no hex digits).
                JNE 	NOTESCAPE               
				J 		ESCAPE					; Yes, generate ESC sequence.
					
NOTESCAPE:
                JBR     off(MODE).6, NOTSTOR	; Jump if store mode flag is not set
                JBR 	off(MODE).0, BYTEMODE	; Jump if word flag is not set
				L 		A, off(HEX_LOW)			; Word mode, get data
				MOV 	DP, off(STL)			; Get address
				ST 		A, [DP]					; Store data to address
				J 		GETLINE					; done
BYTEMODE:
				LB      A, off(HEX_LOW)        	; LSD's of hex data.
                MOV 	DP, off(STL)	
				STB 	A, [DP]	
				INCB    off(STL)               	; Increment store index.
                JNE     NEXTITEM               	; Get next item (no carry).
                INCB    off(STH)               	; Add carry to 'store index
TONEXTITEM:     
			    JBR 	off(MODE).5, NEXTITEM
				J 		GETLINE
				;J       NEXTITEM               ; Get next command item.

RUN:

                J     [off(XAML)]              	; Run at current XAM index.

NOTSTOR:
                
				JBS     off(MODE).7, XAMNEXT   	; B7 = 0 for XAM, 1 for BLOCK XAM.
	
SETADR:	
				L 		A, off(HEX_LOW)        	; Copy hex data to
				ST 		A, off(STL)            	;  'store index
				ST 		A, off(XAML)           	; And to 'XAM index
				CLR 	A                      	
	
NXTPRNT:	
                JNE     PRDATA                 	; NE means no address to print.
                LB      A, #00dh               	; CR.
                CAL     ECHO                   	; Output it.
				LB      A, #00ah               	; NL
                CAL     ECHO                   	; Output it.
                LB      A, off(XAMH)           	; 'Examine index' high-order byte.
                CAL     PRBYTE                 	; Output it in hex format.
                LB      A, off(XAML)           	; Low-order 'examine index byte.
                CAL     PRBYTE                 	; Output it in hex format.
                LB      A, #03Ah               	; ":".
                CAL     ECHO                   	; Output it.
	
PRDATA:	
                LB      A, #020h               	; Blank.
                CAL     ECHO                   	; Output it.
                MOV 	DP, off(XAML)	
				LB 		A, [DP]                	; Get data from XAM address
                CAL     PRBYTE                 	; Output it in hex format.
XAMNEXT:        	
                ;CLRB 	off(MODE)              	; 0 -> MODE (XAM mode).
				ANDB 	off(MODE), #03fh       	; Clear wozmon mode bits
				CMP 	off(XAML), off(HEX_LOW)	
					
				JEQ     TONEXTITEM             	; Equal, so no more data to output.
                INC 	off(XAML)              	; Increment 'examine index'.
	
MOD8CHK:	
                LB      A, off(XAML)           	; Check low-order 'examine index byte
                ANDB    A, #007h               	; For MOD 8 = 0
                SJ      NXTPRNT                	; Always taken.
				
	
PRBYTE:	
				PUSHS 	A						; Save A to stack
				LB 		A, ACC					; DD=0
				SWAPB 							; Swap the byte digits
				CAL     PRHEX               	; Output high digit in byte
				POPS 	A						; Get A back
                LB 		A, ACC					; DD=0
	
PRHEX:	
                ANDB    A, #00Fh               	; Mask LSD for hex print.
                ORB     A, #030h               	; Add "0".
                CMPB    A, #03Ah               	; Digit?
                JLT     ECHO                   	; Yes, output it.
                ADDB    A, #007h               	; Add offset for letter.
	
ECHO:			
				STB     A, SERIAL_STBUF      	; Output character.
				MOV		X2, #SERIAL_DELAY	
serialDelay:		
				CAL 	WDT_feeder	
				DEC 	X2	
				JNE 	serialDelay	
				RT                             	; Return.
;------------------------ ASIC Feeder---------------------------------------------------
;Services ASIC chip on board so it doesn't take over I/O
;The delay is non blocking, and depends on the time that it takes the rest of the code to run.
;If changes are made to the rest of the code (eg the Serial Delay) adjustments may be needed
WDT_feeder:
				INCB 	r7
				JNE		exitFeed
				XORB    ASICPORT_OUT, #ASICPIN
exitFeed:		RT
;------------------------- Strings -----------------------------------------------------

Woz_sendString:	LCB 	A, [X1]						; Load byte from ROM string in X1
				JEQ 	Woz_doneSending				; Found 0x00 termination byte, stop sending
				CAL 	ECHO						; Send byte
				INC 	X1							; Increment pointer to next byte
				SJ 		Woz_sendString        		; Repeat

Woz_doneSending:	
				CLR 	X1						; Tidy up and return 
				RT	

WZS_terminal:
				ds 		"WozMon v"
				DB 		VERSION_MAJOR + 030H
				DS 		"."
				DB 		(VERSION_MINOR / 10) + 030H
				DB 		(VERSION_MINOR % 10) + 030H
				DS 		">"
				DB		000H				
WOZMON_END:
