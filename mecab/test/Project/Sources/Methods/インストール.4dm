//%attributes = {"invisible":true}
C_OBJECT:C1216($model)
$model:=JSON Parse:C1218(MeCab Get model; Is object:K8:27)

If ($model=Null:C1517)
	
	$model:=New object:C1471
	$model.dicdir:=Get 4D folder:C485(Current resources folder:K5:16)+"ipadic"
	
	MeCab SET MODEL(JSON Stringify:C1217($model))
	
End if 