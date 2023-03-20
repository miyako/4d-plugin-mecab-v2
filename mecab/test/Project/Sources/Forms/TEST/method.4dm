$event:=Form event code:C388

Case of 
	: ($event=On Load:K2:1)
		
		Form:C1466.q:="リバルディエールさんをルペックでみかけた"
		
		Form:C1466.model:=JSON Parse:C1218(MeCab Get model; Is object:K8:27)
		Form:C1466.dicname:=Path to object:C1547(Form:C1466.model.dicdir; Path is system:K24:25).name
		
		Case of 
			: (Form:C1466.dicname="ipadic")
				
				Form:C1466.ipadic:=1
				Form:C1466.jumandic:=0
				
			: (Form:C1466.dicname="jumandic")
				
				Form:C1466.ipadic:=0
				Form:C1466.jumandic:=1
				
			Else 
				
				Form:C1466.ipadic:=0
				Form:C1466.jumandic:=0
				Form:C1466.other:=1
				
		End case 
		
		Form:C1466.nodes:=JSON Parse:C1218(MeCab(Form:C1466.q); Is collection:K8:32)
		
End case 