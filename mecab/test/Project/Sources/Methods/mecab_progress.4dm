//%attributes = {"invisible":true}
C_TEXT:C284($1; $message)
C_LONGINT:C283($2; $event; $3; $current; $4; $total)
C_BOOLEAN:C305($0; $abort)

$event:=$2

Case of 
	: ($event=1)  //open file
		
		$message:="open "+$1
		MESSAGE:C88($message)
		
	: ($event=2)  //create file
		
		$message:="create "+$1
		MESSAGE:C88($message)
		
	: ($event=3)  //emit double array
		
		$message:="emitting double array "+String:C10($3)+"/"+String:C10($4)
		MESSAGE:C88($message)
		
	: ($event=4)  //emit matrix
		
		$message:="emitting matrix "+String:C10($3)+"x"+String:C10($4)
		MESSAGE:C88($message)
		
	: ($event=-1)
		
		$message:="missing "+$1
		MESSAGE:C88($message)
		
	: ($event=-2)
		
		$message:="missing csv "+$1
		MESSAGE:C88($message)
		
	: ($event=-3)
		
		$message:="invalid model "+$1
		MESSAGE:C88($message)
		
	: ($event=-4)
		
		$message:="invalid csv "+$1
		MESSAGE:C88($message)
		
	: ($event=5)  //error open file
		
		$message:="error open "+$1
		MESSAGE:C88($message)
		
	: ($event=6)  //error create file
		
		$message:="error create "+$1
		MESSAGE:C88($message)
		
	: ($event=-7)
		
		$message:="invalid def "+$1
		MESSAGE:C88($message)
		
	: ($event=-8)
		
		$message:="invalid dicrc "+$1
		MESSAGE:C88($message)
		
	: ($event=-9)
		
		$message:="error write "+$1
		MESSAGE:C88($message)
		
End case 

DELAY PROCESS:C323(Current process:C322; 0)
