If (Form event code:C388=On Clicked:K2:4)
	
	If (Form:C1466.dicname#OBJECT Get name:C1087(Object current:K67:2))
		
		Form:C1466.dicname:=OBJECT Get name:C1087(Object current:K67:2)
		
		Form:C1466.model.dicdir:=Get 4D folder:C485(Current resources folder:K5:16)+Form:C1466.dicname
		Form:C1466.model.userdic:=Null:C1517
		
		MeCab SET MODEL(JSON Stringify:C1217(Form:C1466.model))
		Form:C1466.model:=JSON Parse:C1218(MeCab Get model; Is object:K8:27)
		Form:C1466.nodes:=JSON Parse:C1218(MeCab(Form:C1466.q); Is collection:K8:32)
		
	End if 
	
End if 