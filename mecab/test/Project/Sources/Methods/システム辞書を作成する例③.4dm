//%attributes = {}
//システム辞書を作成する例（ipadic-euc-jp）

//作業フォルダーを用意
$dictPath:=System folder:C487(Desktop:K41:16)+"ipadic-sys"+Folder separator:K24:12
DELETE FOLDER:C693($dictPath; Delete with contents:K24:24)
CREATE FOLDER:C475($dictPath; *)

//辞書データの設定
C_OBJECT:C1216($options)
$options:=New object:C1471

//出力SYS.DICフォルダーパス
$options.outdir:=$dictPath

//入力CSVファイルのフォルダーパス（ダウンロードした辞書のソースファイル群）
$options.sysdicdir:=System folder:C487(Desktop:K41:16)+"mecab-ipadic-euc-jp"+Folder separator:K24:12
$options.dictionaryCharset:="EUC-JP"  //入力CSVファイルの文字コード

//設定ファイルの場所
$options.dicdir:=Get 4D folder:C485(Current resources folder:K5:16)+"ipadic"
$options.configCharset:="EUC-JP"  //設定ファイルの文字コード

//作成するファイルの指定　（カッコ内は依存設定ファイル）
$options.buildUnknown:=True:C214  //unk.dic (unk.def)
$options.buildSysdic:=True:C214  //sys.dic (unk.def)
$options.buildMatrix:=True:C214  //matrix.bin (matrix.def)
$options.buildCharCategory:=True:C214  //char.bin (char.def,unk.def)
$options.buildModel:=True:C214  //model.bin (model.def)

//辞書ファイルのコンパイル

$method:="mecab_progress"
MeCab INDEX DICTIONARY(JSON Stringify:C1217($options); $method)

//辞書設定ファイルのコピー（システム）
COPY DOCUMENT:C541($options.sysdicdir+"dicrc"; $options.outdir+"dicrc"; *)

//辞書設定ファイルコピー（ユーザー）
COPY DOCUMENT:C541($options.sysdicdir+"left-id.def"; $options.outdir+"left-id.def"; *)
COPY DOCUMENT:C541($options.sysdicdir+"pos-id.def"; $options.outdir+"pos-id.def"; *)
COPY DOCUMENT:C541($options.sysdicdir+"rewrite.def"; $options.outdir+"rewrite.def"; *)
COPY DOCUMENT:C541($options.sysdicdir+"right-id.def"; $options.outdir+"right-id.def"; *)
COPY DOCUMENT:C541($options.sysdicdir+"feature.def"; $options.outdir+"feature.def"; *)

//システム辞書を使用
C_OBJECT:C1216($model)
$model:=New object:C1471
$model.dicdir:=$dictPath

MeCab SET MODEL(JSON Stringify:C1217($model))

$window:=Open form window:C675("TEST")
DIALOG:C40("TEST")