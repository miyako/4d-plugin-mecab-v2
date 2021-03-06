# 4d-plugin-mecab-v2
4D implementation of [MeCab](http://taku910.github.io/mecab/)

### できること

* システム辞書のコンパイル（コールバックメソッド付き）

* ユーザー辞書のコンパイル（コールバックメソッド付き）

* 辞書の切り替え（システム辞書１＋任意数のユーザー辞書）

### TODO

[オリジナル辞書/コーパスからのパラメータ推定](https://taku910.github.io/mecab/learn.html)に必要な``mecab-cost-train``および``mecab-dict-gen``に相当するコマンド

### Platform

| carbon | cocoa | win32 | win64 |
|:------:|:-----:|:---------:|:---------:|
||<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|

### Version

<img width="32" height="32" src="https://user-images.githubusercontent.com/1725068/73986501-15964580-4981-11ea-9ac1-73c5cee50aae.png"> <img src="https://user-images.githubusercontent.com/1725068/73987971-db2ea780-4984-11ea-8ada-e25fb9c3cf4e.png" width="32" height="32" />

### Releases

[1.0](https://github.com/miyako/4d-plugin-mecab-v2/releases/tag/0.1-db) サンプルプログラム＋プラグイン  

[1.0](https://github.com/miyako/4d-plugin-mecab-v2/releases/tag/0.1) プラグインのみ  

## Install

プラグインには辞書ファイルが含まれていません。

下記のファイルをダウンロードしておき，スタートアップで``MeCab SET MODEL``を実行してください。

サンプルプログラムのResourcesフォルダーには，これらのファイルが含まれています。  

* [ipadic-utf8-compiled](https://github.com/miyako/4d-plugin-mecab-v2/releases/download/mecab-ipadic-utf8-compiled/ipadic.zip)

* [jumandic-utf8-compiled](https://github.com/miyako/4d-plugin-mecab-v2/releases/download/mecab-jumandic-utf8-compiled/jumandic.zip)

```
C_OBJECT($model)
$model:=JSON Parse(MeCab Get model ;Is object)

If ($model=Null)
	
	$model:=New object
	$model.dicdir:=Get 4D folder(Current resources folder)+"jumandic"
	
	MeCab SET MODEL (JSON Stringify($model))
	
end if
```

コスト自動計算モード（``assignUserDictionaryCosts``）でユーザー辞書を作成するためには

* ``rewrite.def``  
* ``char.bin``  
* ``model.bin``  
* ``feature.def``  

が必要です。

``rewrite.def``と``char.bin``は辞書に含まれています。

``model.bin``と``feature.def``は下記からダウンロードすることができます。

サンプルプログラムのResourcesフォルダーには，これらのファイルが含まれています。  

* [mecab-ipadic-utf8-conf](https://github.com/miyako/4d-plugin-mecab-v2/releases/download/mecab-ipadic-utf8-conf/ipadic.utf8.zip)

* [mecab-jumandic-utf8-conf](https://github.com/miyako/4d-plugin-mecab-v2/releases/download/mecab-jumandic-utf8-conf/jumandic.utf8.zip)

システム辞書から``model.bin``を作成するためには，``model.def``が必要です。IPA辞書の学習モデルはmecabやmecab-ipadicのソースコードと一緒に配布されていませんでした。

* [mecab-ipadic-2.7.0-20070801.model](https://github.com/miyako/4d-plugin-mecab-v2/releases/download/ipa-model/mecab-ipadic-2.7.0-20070801.model)

システム辞書を作成するには，CSVファイルおよび設定ファイル群が必要です。公式版IPA辞書のように，EUC-JPのCSVから作成することもできますが，その場合，モデルファイルもEUC-JPとなるため，コスト自動計算モードでユーザー辞書を作成することができません。UTF-8版のCSVファイルは，下記からダウンロードすることができます。

なお，サンプルプログラムは，これらのファイルがデスクトップにあるという前提で書かれています。

* [mecab-jumandic-utf8.zip](https://github.com/miyako/4d-plugin-mecab-v2/releases/download/mecab-jumandic-utf8-erc/mecab-jumandic-utf8.zip)

* [mecab-ipadic-utf8.zip](https://github.com/miyako/4d-plugin-mecab-v2/releases/download/mecab-ipadic-utf8-src/mecab-ipadic-utf8.zip)

## Syntax

```
model:=MeCab Get model
```

Parameter|Type|Description
------------|------------|----
model|TEXT|``JSON``

現在のmecab設定を返します。この設定は，アプリケーション全体，つまりすべてのプロセスに対して共通です。

``dicdir``: システム辞書のディレクトリパス (``Path is system``)  
``version``: ライブラリのバージョン文字列（``0.996``）  
``dict[]``: 辞書情報（下記オブジェクトのコレクション）  

``filename``: 辞書ファイル名 (``Path is POSIX``)  
``charset``: 文字セット（``utf8``）  
``size``: 登録語数  
``type``: ``0`` システム辞書 ``1`` ユーザー辞書 ``2`` 未知語辞書  
``lsize``: ``left``属性数  
``rsize`` ``right``属性数  
``version``: 辞書バージョン（``102``）  

```
MeCab SET MODEL (model)
```

Parameter|Type|Description
------------|------------|----
model|TEXT|``JSON``

``dicdir``: システム辞書のディレクトリパス (``Path is system``)  
``userdic[]`` or ``userdic``: ユーザー辞書のファイルパス (``Path is system``)  

* ``userdic``（任意）には，文字列または文字列のコレクションが渡せます。

```
result:=MeCab (sentence)
```

Parameter|Type|Description
------------|------------|----
sentence|TEXT|sentence
result|TEXT|``JSON``

形態素分析の結果を返します。（下記オブジェクトのコレクション）

``feature``: 素性  
``value``: 表層形  
``rcAttr``: 右連接状態番号 
``lcAttr``: 左連接状態番号
``cost``: コスト
``posid``: 形態素ID  
``char_type``: 文字種ID  
``stat``: 形態素種類ID  
``isbest``: 最適パス (``true`` ``false``)  

素性CSVのフォーマット，各種IDは辞書依存です。

ipadic: 品詞,品詞細分類1,品詞細分類2,品詞細分類3,活用形,活用型,原形,読み,発音

## 辞書を切り替えるには

```  
$model:=JSON Parse(MeCab Get model)

$model.dicdir:=Path to object($model.dicdir;Path is system).parentFolder+"jumandic"

MeCab SET MODEL (JSON Stringify($model))
```

## 形態素の配列を取り出すには

```
$sentence:="太郎は次郎が持っている本を花子に渡した。"

$result:=JSON Parse(MeCab($sentence);Is collection)
$words:=$result.extract("value")
```

<img width="800" alt="2018-12-17 10 00 59" src="https://user-images.githubusercontent.com/1725068/50061348-ce7c4c80-01e2-11e9-9443-8f29f0ffee17.png">

## N-best解を取り出すには

```
$sentence:="ははははははと笑った"

C_OBJECT($options)
$options:=New object("nbest";2;"theta";0.5)

$results:=JSON Parse(MeCab ($sentence;JSON Stringify($options));Is collection)

C_COLLECTION($result;$words)
$words:=New collection()

For each ($result;$results)
	$words.push($result.extract("value"))
End for each 
```

<img width="800" alt="2018-12-17 11 30 13" src="https://user-images.githubusercontent.com/1725068/50063356-64b66f80-01ef-11e9-901f-a07ebd8c17b5.png">

```
MeCab INDEX DICTIONARY (options{;method})
```

Parameter|Type|Description
------------|------------|----
model|TEXT|``JSON``
method|TEXT|callback (TEXT;LONGINT;LONGINT;LONGINT)

システム辞書またはユーザー辞書を作成します。``mecab-dict-index``のようなものです。

## コールバックメソッドの例

```
C_TEXT($1;$message)
C_LONGINT($2;$event;$3;$current;$4;$total)
C_BOOLEAN($0;$abort)

$event:=$2

Case of 
	: ($event=1)  //open file
		
		$message:="open "+$1
		MESSAGE($message)
		
	: ($event=2)  //create file
		
		$message:="create "+$1
		MESSAGE($message)
		
	: ($event=3)  //emit double array
		
		$message:="emitting double array "+String($3)+"/"+String($4)
		MESSAGE($message)
		
	: ($event=4)  //emit matrix
		
		$message:="emitting matrix "+String($3)+"x"+String($4)
		MESSAGE($message)
		
	: ($event=-1)
		
		$message:="missing "+$1
		MESSAGE($message)
		
	: ($event=-2)
		
		$message:="missing csv "+$1
		MESSAGE($message)
		
	: ($event=-3)
		
		$message:="invalid model "+$1
		MESSAGE($message)
		
	: ($event=-4)
		
		$message:="invalid csv "+$1
		MESSAGE($message)
		
	: ($event=5)  //error open file
		
		$message:="error open "+$1
		MESSAGE($message)
		
	: ($event=6)  //error create file
		
		$message:="error create "+$1
		MESSAGE($message)
		
	: ($event=-7)
		
		$message:="invalid def "+$1
		MESSAGE($message)
		
	: ($event=-8)
		
		$message:="invalid dicrc "+$1
		MESSAGE($message)
		
	: ($event=-9)
		
		$message:="error write "+$1
		MESSAGE($message)
		
End case 
```

## システム辞書を作成するには

* 必須プロパティ

``options.outdir``: 出力フォルダーパス  
``options.sysdicdir``: 入力フォルダーパス（CSVファイルの場所）  
``options.dicdir``: 設定フォルダーパス    

* 任意プロパティ

``options.configCharset``: 設定ファイルの文字コード（既定：``EUC-JP``）  
``options.dictionaryCharset``: 入力CSVファイルの文字コード（既定：``EUC-JP``）  

出力ファイルの文字コードはUTF-8固定です。

``options.buildUnknown``: ``unk.dic``を出力（既定：``false``）  
``options.buildMatrix``: ``matrix.bin``を出力（既定：``false``, ``matrix.def``必要）  
``options.buildCharCategory``: ``char.bin``を出力（既定：``false``; ``char.def``, ``unk.def``必要）  
``options.buildSysdic``: ``sys.dic``を出力（既定：``true``）   
``options.buildModel``: ``model.bin``を出力（既定：``false``; ``model.def``必要）      
``options.model``: ``model.def``のファイルパス（既定：``$(dicdir)/model.def``）    

``matrix.def``未指定の場合，既定（``1 1\n0 0 0\n``）が使用されます。

``char.def``未指定の場合，既定（``DEFAULT 1 0 0\nSPACE   0 1 0\n0x0020 SPACE\n``）が使用されます。

``unk.def``未指定の場合，既定（``DEFAULT,0,0,0,*\nSPACE,0,0,0,*\n``）が使用されます。

 ``model.bin``を出力する場合，辞書の文字コード（``dictionaryCharset``）は出力ファイルの文字コード（``utf8``）と合致していなければなりません。
 
 システム辞書ファイルとして使用するフォルダーには``dicrc``ファイルがなければなりません。
 
```
  //システム辞書を作成する例（ipadic-utf8）

  //作業フォルダーを用意
$dictPath:=System folder(Desktop)+"ipadic-sys"+Folder separator
DELETE FOLDER($dictPath;Delete with contents)
CREATE FOLDER($dictPath;*)

  //辞書データの設定
C_OBJECT($options)
$options:=New object

  //出力SYS.DICフォルダーパス
$options.outdir:=$dictPath

  //入力CSVファイルのフォルダーパス（ダウンロードした辞書のソースファイル群）
$options.sysdicdir:=System folder(Desktop)+"mecab-ipadic-utf8"+Folder separator
$options.dictionaryCharset:="UTF-8"  //入力CSVファイルの文字コード

  //設定ファイルの場所
$options.dicdir:=Get 4D folder(Current resources folder)+"ipadic"
$options.configCharset:="UTF-8"  //設定ファイルの文字コード

  //作成するファイルの指定　（カッコ内は依存設定ファイル）
$options.buildUnknown:=True  //unk.dic (unk.def)
$options.buildSysdic:=True  //sys.dic (unk.def)
$options.buildMatrix:=True  //matrix.bin (matrix.def)
$options.buildCharCategory:=True  //char.bin (char.def,unk.def)
$options.buildModel:=True  //model.bin (model.def)

  //辞書ファイルのコンパイル

$method:="mecab_progress"
MeCab INDEX DICTIONARY (JSON Stringify($options);$method)

  //辞書設定ファイルのコピー（システム）
COPY DOCUMENT($options.sysdicdir+"dicrc";$options.outdir+"dicrc";*)

  //辞書設定ファイルコピー（ユーザー）
COPY DOCUMENT($options.sysdicdir+"left-id.def";$options.outdir+"left-id.def";*)
COPY DOCUMENT($options.sysdicdir+"pos-id.def";$options.outdir+"pos-id.def";*)
COPY DOCUMENT($options.sysdicdir+"rewrite.def";$options.outdir+"rewrite.def";*)
COPY DOCUMENT($options.sysdicdir+"right-id.def";$options.outdir+"right-id.def";*)
COPY DOCUMENT($options.sysdicdir+"feature.def";$options.outdir+"feature.def";*)

  //システム辞書を使用
C_OBJECT($model)
$model:=New object
$model.dicdir:=$dictPath

MeCab SET MODEL (JSON Stringify($model))

$window:=Open form window("TEST")
DIALOG("TEST")
```
 
## ユーザー辞書を作成するには

* 必須プロパティ

``options.userdic``: 出力ファイルパス  
``options.userdicdir``: 入力フォルダーパス（CSVファイルの場所）  
``options.dicdir``: 設定フォルダーパス    

* 任意プロパティ

``options.assignUserDictionaryCosts``: 自動コスト計算で``.csv``を出力（既定：``false``; ``model``, ``char``, ``feature``を参照）   
``options.model``: ``model.def``または``model.bin``のファイルパス（既定：``$(dicdir)/model.bin``）   
``options.feature``: ``feature.def``のファイルパス（既定：``$(dicdir)/feature.def``）  

* ``dicdir``に用意しておくもの（``assignUserDictionaryCosts=true``の場合）

``matrix.bin``または``matrix.def``  
``dicrc``  
``left-id.def``  
``right-id.def``  
``rewrite.def``  
``char.bin``  

* ``dicdir``に用意しておくもの（``assignUserDictionaryCosts=false``の場合）

``matrix.bin``または``matrix.def``  
``dicrc``  
``left-id.def``  
``right-id.def``  
``rewrite.def``  
``pos-id.def``  

## ユーザー辞書を作成するには（自動コスト計算）

```
  //ユーザー辞書を作成する例（ipadic/コスト自動計算）

  //作業フォルダーを用意
$dictPath:=System folder(Desktop)+"ipadic-usr"+Folder separator
DELETE FOLDER($dictPath;Delete with contents)
CREATE FOLDER($dictPath;*)

  //CSVファイルを作成
C_COLLECTION($data;$datum)
$data:=New collection

  //1行目は空データにする（つぎの連結コストがマイナスにならないように）
$data.push(New collection("";0;0;0;"";"";"";"";"";"";"";"";""))

  //単語データは2行目以降に
$data.push(New collection("ルペック";1293;1293;10000;"名詞";"固有名詞";"地域";"一般";"*";"*";"ルペック";"ルペック";"ルペック"))
$data.push(New collection("リバルディエール";1291;1291;10000;"名詞";"固有名詞";"人名";"名";"*";"*";"リバルディエール";"リバルディエール";"リバルディエール"))

$csv:=New collection
For each ($datum;$data)
	$csv.push($datum.join(","))
End for each 
  //改行コードはLFで
TEXT TO DOCUMENT($dictPath+"data.csv";$csv.join("\n");"utf-8";Document unchanged)

  //辞書データの設定
C_OBJECT($options)
$options:=New object

  //出力DICファイルパス
$options.userdic:=$dictPath+"$"+Generate UUID+".csv"

  //入力CSVファイルのフォルダーパス
$options.userdicdir:=$dictPath
$options.dictionaryCharset:="UTF-8"  //入力CSVファイルの文字コード

  //設定ファイルの場所
$options.dicdir:=Get 4D folder(Current resources folder)+"ipadic"
$options.configCharset:="UTF-8"  //設定ファイルの文字コード

$options.assignUserDictionaryCosts:=True

  //追加の設定ファイル
$options.model:=Get 4D folder(Current resources folder)+"ipadic.utf8.model.bin"
$options.feature:=Get 4D folder(Current resources folder)+"ipadic.utf8.feature.def"

  //コストの自動計算
$method:="mecab_progress"
MeCab INDEX DICTIONARY (JSON Stringify($options);$method)

MOVE DOCUMENT($dictPath+"data.csv";$dictPath+"data.txt")
MOVE DOCUMENT($options.userdic;$dictPath+"data.csv")

$options.assignUserDictionaryCosts:=False  //コストの自動計算モードをここでオフにする
$options.userdic:=$dictPath+"data.dic"

  //辞書ファイルの作成
MeCab INDEX DICTIONARY (JSON Stringify($options);$method)

  //システム辞書＋ユーザー辞書を使用
C_OBJECT($model)
$model:=New object
$model.dicdir:=Get 4D folder(Current resources folder)+"ipadic"
$model.userdic:=$options.userdic

MeCab SET MODEL (JSON Stringify($model))
$model:=JSON Parse(MeCab Get model )

$window:=Open form window("TEST")
DIALOG("TEST")
```

## ユーザー辞書を作成するには（モデル無し）

```
  //ユーザー辞書を作成する例（ipadic/コスト指定）

  //作業フォルダーを用意
$dictPath:=System folder(Desktop)+"ipadic-usr"+Folder separator
DELETE FOLDER($dictPath;Delete with contents)
CREATE FOLDER($dictPath;*)

  //CSVファイルを作成
C_COLLECTION($data;$datum)
$data:=New collection

  //1行目は空データにする（つぎの連結コストがマイナスにならないように）
$data.push(New collection("";-1;-1;0;"";"";"";"";"";"";"";"";""))

  //単語データは2行目以降に
$data.push(New collection("ルペック";1293;1293;1;"名詞";"固有名詞";"地域";"一般";"*";"*";"ルペック";"ルペック";"ルペック"))
$data.push(New collection("リバルディエール";1291;1291;1;"名詞";"固有名詞";"人名";"名";"*";"*";"リバルディエール";"リバルディエール";"リバルディエール"))

$csv:=New collection
For each ($datum;$data)
	$csv.push($datum.join(","))
End for each 
  //改行コードはLFで
TEXT TO DOCUMENT($dictPath+"data.csv";$csv.join("\n");"utf-8";Document unchanged)

  //辞書データの設定
C_OBJECT($options)
$options:=New object

  //出力DICファイルパス
$options.userdic:=$dictPath+"data.dic"

  //入力CSVファイルのフォルダーパス
$options.userdicdir:=$dictPath
$options.dictionaryCharset:="UTF-8"  //入力CSVファイルの文字コード

  //設定ファイルの場所
$options.dicdir:=Get 4D folder(Current resources folder)+"ipadic"
$options.configCharset:="UTF-8"  //設定ファイルの文字コード

$options.assignUserDictionaryCosts:=False

  //辞書ファイルのコンパイル
$method:="mecab_progress"
MeCab INDEX DICTIONARY (JSON Stringify($options);$method)

  //システム辞書＋ユーザー辞書を使用
C_OBJECT($model)
$model:=New object
$model.dicdir:=Get 4D folder(Current resources folder)+"ipadic"
$model.userdic:=$options.userdic
MeCab SET MODEL (JSON Stringify($model))
$model:=JSON Parse(MeCab Get model )

$window:=Open form window("TEST")
DIALOG("TEST")
```
