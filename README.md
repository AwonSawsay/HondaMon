# HondaMon
A port of WozMon to Honda OBD-I ECUs.  
Original Woz Monitor by Steve Wozniak (1976) for the Apple-1.  

Enable full duplex serial on ECU , flash Bin to chip or emulator, and connect serial monitor at 38400 8N1.  

Usage:
  Address 					        -	Get byte value at address
  Address1 Address2 etc		  -	Get bytes from multiple addresses
  AddressLow.AddressHigh	  -	Get all data between addresses
  Address:Data				      -	Set byte at address
  Address:Data1 Data 2 etc	-	Set bytes, starting at address
	Address-DataWord			    -	Set word at address
  ROMAddressR (eg 300R)		  -	Execute code at ROM address		
  [!Terminal screenshot](screenshot.png)

