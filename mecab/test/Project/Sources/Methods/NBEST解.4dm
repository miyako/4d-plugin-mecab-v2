//%attributes = {}
//N-best解の例

$sentence:="筋萎縮性側索硬化症"

C_OBJECT:C1216($options)
$options:=New object:C1471("nbest"; 2; "theta"; 0.5)

C_COLLECTION:C1488($results)
$results:=JSON Parse:C1218(MeCab($sentence; JSON Stringify:C1217($options)); Is collection:K8:32)

C_COLLECTION:C1488($result; $words)
$words:=New collection:C1472()

For each ($result; $results)
	$words.push($result.extract("value"))
End for each 