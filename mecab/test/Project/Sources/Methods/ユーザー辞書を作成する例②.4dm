//%attributes = {}
//ユーザー辞書を作成する例（jumandic/コスト自動計算）

//作業フォルダーを用意
$dictPath:=System folder:C487(Desktop:K41:16)+"jumandic-usr"+Folder separator:K24:12
DELETE FOLDER:C693($dictPath; Delete with contents:K24:24)
CREATE FOLDER:C475($dictPath; *)

//CSVファイルを作成
C_COLLECTION:C1488($data; $datum)
$data:=New collection:C1472

//1行目は空データにする（つぎの連結コストがマイナスにならないように）
$data.push(New collection:C1472(""; 0; 0; 0; ""; ""; ""; ""; ""; ""; ""))

//単語データは2行目以降に
$data.push(New collection:C1472("ルペック"; 1129; 1129; 0; "名詞"; "地名"; "*"; "*"; "ルペック"; "ルペック"; "*"))
$data.push(New collection:C1472("リバルディエール"; 1126; 1126; 0; "名詞"; "人名"; "*"; "*"; "リバルディエール"; "リバルディエール"; "*"))

$csv:=New collection:C1472
For each ($datum; $data)
	$csv.push($datum.join(","))
End for each 
//改行コードはLFで
TEXT TO DOCUMENT:C1237($dictPath+"data.csv"; $csv.join("\n"); "utf-8"; Document unchanged:K24:18)

//辞書データの設定
C_OBJECT:C1216($options)
$options:=New object:C1471

//出力DICファイルパス
$options.userdic:=$dictPath+"$"+Generate UUID:C1066+".csv"

//入力CSVファイルのフォルダーパス
$options.userdicdir:=$dictPath
$options.dictionaryCharset:="UTF-8"  //入力CSVファイルの文字コード

//設定ファイルの場所
$options.dicdir:=Get 4D folder:C485(Current resources folder:K5:16)+"jumandic"
$options.configCharset:="UTF-8"  //設定ファイルの文字コード

$options.assignUserDictionaryCosts:=True:C214

//追加の設定ファイル
$options.model:=Get 4D folder:C485(Current resources folder:K5:16)+"jumandic.utf8.model.bin"
$options.feature:=Get 4D folder:C485(Current resources folder:K5:16)+"jumandic.utf8.feature.def"

//コストの自動計算
$method:="mecab_progress"
MeCab INDEX DICTIONARY(JSON Stringify:C1217($options); $method)

MOVE DOCUMENT:C540($dictPath+"data.csv"; $dictPath+"data.txt")
MOVE DOCUMENT:C540($options.userdic; $dictPath+"data.csv")

$options.assignUserDictionaryCosts:=False:C215  //コストの自動計算モードをここでオフにする
$options.userdic:=$dictPath+"data.dic"

//辞書ファイルの作成
MeCab INDEX DICTIONARY(JSON Stringify:C1217($options); $method)

//システム辞書＋ユーザー辞書を使用
C_OBJECT:C1216($model)
$model:=New object:C1471
$model.dicdir:=Get 4D folder:C485(Current resources folder:K5:16)+"jumandic"
$model.userdic:=$options.userdic

MeCab SET MODEL(JSON Stringify:C1217($model))
$model:=JSON Parse:C1218(MeCab Get model)

$window:=Open form window:C675("TEST")
DIALOG:C40("TEST")