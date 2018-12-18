# 4d-plugin-mecab-v2
4D implementation of [MeCab](http://taku910.github.io/mecab/)

### Platform

| carbon | cocoa | win32 | win64 |
|:------:|:-----:|:---------:|:---------:|
|<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|

use [carbon] branch for 32-bit support

### Version

<img src="https://cloud.githubusercontent.com/assets/1725068/18940648/2192ddba-8645-11e6-864d-6d5692d55717.png" width="32" height="32" /> <img src="https://user-images.githubusercontent.com/1725068/41266195-ddf767b2-6e30-11e8-9d6b-2adf6a9f57a5.png" width="32" height="32" />

![preemption xx](https://user-images.githubusercontent.com/1725068/41327179-4e839948-6efd-11e8-982b-a670d511e04f.png)

### Releases

[1.0]

## Install

プラグインには辞書ファイルが含まれていません。

下記のファイルをダウンロードしておき，スタートアップで``MeCab SET MODEL``を実行してください。

```
C_OBJECT($model)
$model:=JSON Parse(MeCab Get model ;Is object)

If ($model=Null)
	
	$model:=New object
	$model.dicdir:=Get 4D folder(Current resources folder)+"jumandic"
	
	MeCab SET MODEL (JSON Stringify($model))
	
end if
```

[ipadic](https://github.com/miyako/4d-plugin-mecab-v2/releases/tag/ipadic)

[jumandic](https://github.com/miyako/4d-plugin-mecab-v2/releases/tag/jumandic)

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
``charset``: 文字セット  
``size``: 登録語数  
``type``: ``0`` システム辞書 ``1`` ユーザー辞書 ``2`` 未知語辞書  
``lsize``: ``left``属性数  
``rsize`` ``right``属性数  
``version``: 辞書バージョン  

プラグインのResourcesフォルダーには``UTF-8``版の``ipadic``および``jumandic``辞書が収録されています。

## 辞書を切り替えるには

```  
$model:=JSON Parse(MeCab Get model)

$model.dicdir:=Path to object($model.dicdir;Path is system).parentFolder+"jumandic"

MeCab SET MODEL (JSON Stringify($model))
```

```
MeCab SET MODEL (model)
```

Parameter|Type|Description
------------|------------|----
model|TEXT|``JSON``

``dicdir``: システム辞書のディレクトリパス (``Path is system``)  
``userdic[]`` or ``userdic``: ユーザー辞書のファイルパス (``Path is system``)  

* ``userdic``には文字列または文字列のコレクションが渡せます。

```
result:=MeCab (sentence)
```

Parameter|Type|Description
------------|------------|----
sentence|TEXT|sentence
result|TEXT|``JSON``

形態素分析の結果を返します。（下記オブジェクトのコレクション）

``feature``: 素性（ipadic:品詞,品詞細分類1,品詞細分類2,品詞細分類3,活用形,活用型,原形,読み,発音）  
``value``: 表層形  
``rcAttr``: 右連接状態番号 
``lcAttr``: 左連接状態番号
``cost``: コスト
``posid``: 形態素ID  
``char_type``: 文字種ID  
``stat``: 形態素種類ID  
``isbest``: 最適パス (``true`` ``false``)  

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
``options.buildMatrix``: ``matrix.bin``を出力（既定：``false``, ``matrix``を参照）  
``options.buildCharCategory``: ``char.bin``を出力（既定：``false``; ``char``, ``unk``を参照）  
``options.buildSysdic``: ``sys.dic``を出力（既定：``true``）   
``options.buildModel``: ``model.bin``を出力（既定：``false``; ``model``が無ければ無視）  
``options.matrix``: ``matrix.def``のファイルパス    
``options.char``: ``char.def``のファイルパス    
``options.unk``: ``unk.def``のファイルパス
``options.model``: ``model.def``のファイルパス  

``matrix.def``未指定の場合，既定（``1 1\n0 0 0\n``）が使用されます。

``char.def``未指定の場合，既定（``DEFAULT 1 0 0\nSPACE   0 1 0\n0x0020 SPACE\n``）が使用されます。

``unk.def``未指定の場合，既定（``DEFAULT,0,0,0,*\nSPACE,0,0,0,*\n``）が使用されます。

 ``model.bin``を出力する場合，辞書の文字コード（``dictionaryCharset``）は出力ファイルの文字コード（``utf8``）と合致していなければなりません。
 
```
  //システム辞書を作成する例（ipadic）

  //作業フォルダーを用意
$dictPath:=System folder(Desktop)+"ipadic-sys"+Folder separator
DELETE FOLDER($dictPath;Delete with contents)
CREATE FOLDER($dictPath;*)

  //辞書データの設定
C_OBJECT($options)
$options:=New object

  //出力SYS.DICフォルダーパス
$options.outdir:=$dictPath

  //入力CSVファイルのフォルダーパス
$options.sysdicdir:=System folder(Desktop)+"mecab-ipadic"+Folder separator

  //設定ファイル（dicrc,matrix.bin,pos-id.def,rewrite.def,left-id.def,right-id.def）の場所
$options.dicdir:=Get 4D folder(Current resources folder)+"ipadic"
$options.configCharset:="EUC-JP"  //設定ファイルの文字コード（ipaはEUC-JP）
$options.dictionaryCharset:="EUC-JP"  //入力CSVファイルの文字コード（ipaはEUC-JP）

  //出力DICファイルの文字コードはUTF-8固定

$options.matrix:=$options.sysdicdir+"matrix.def"  //not matrix.bin
$options.char:=$options.sysdicdir+"char.def"  //not char.bin
$options.unk:=$options.sysdicdir+"unk.def"
$options.model:=$options.sysdicdir+"model.def"  //not model.bin

$options.buildUnknown:=True
$options.buildMatrix:=True
$options.buildCharCategory:=True
$options.buildModel:=False  //ipadicのmodelはどこにあるのだろう
$options.buildSysdic:=True

  //辞書ファイルのコンパイル

$method:="mecab_progress"
MeCab INDEX DICTIONARY (JSON Stringify($options);$method)
```
 
```
  //システム辞書を作成する例（jumandic）

  //作業フォルダーを用意
$dictPath:=System folder(Desktop)+"jumandic-sys"+Folder separator
DELETE FOLDER($dictPath;Delete with contents)
CREATE FOLDER($dictPath;*)

  //辞書データの設定
C_OBJECT($options)
$options:=New object

  //出力SYS.DICフォルダーパス
$options.outdir:=$dictPath

  //入力CSVファイルのフォルダーパス
$options.sysdicdir:=System folder(Desktop)+"mecab-jumandic"+Folder separator

  //設定ファイル（dicrc,matrix.bin,pos-id.def,rewrite.def,left-id.def,right-id.def）の場所
$options.dicdir:=Get 4D folder(Current resources folder)+"jumandic"
$options.configCharset:="UTF-8"  //設定ファイルの文字コード（jumanはUTF-8）
$options.dictionaryCharset:="UTF-8"  //入力CSVファイルの文字コード（jumanはUTF-8）

  //出力DICファイルの文字コードはUTF-8固定

$options.matrix:=$options.sysdicdir+"matrix.def"//not matrix.bin
$options.char:=$options.sysdicdir+"char.def"  //not char.bin
$options.unk:=$options.sysdicdir+"unk.def"
$options.model:=$options.sysdicdir+"model.def" //not model.bin

$options.buildUnknown:=True
$options.buildMatrix:=True
$options.buildCharCategory:=True
$options.buildModel:=True 
$options.buildSysdic:=True

  //辞書ファイルのコンパイル

$method:="mecab_progress"
MeCab INDEX DICTIONARY (JSON Stringify($options);$method)
```
 
## ユーザー辞書を作成するには

* 必須プロパティ

``options.userdic``: 出力ファイルパス  
``options.userdicdir``: 入力フォルダーパス（CSVファイルの場所）  
``options.dicdir``: 設定フォルダーパス    
``options.rewrite``: ``rewrite.def``のファイルパス     

* 任意プロパティ

``options.assignUserDictionaryCosts``: 自動コスト計算で``.csv``を出力（既定：``false``; ``model``, ``char``, ``feature``を参照）   

``options.model``: ``model.def``または``model.bin``のファイルパス   
``options.char``: ``char.def``または``char.bin``のファイルパス  
``options.feature``: ``feature.def``のファイルパス  

* ``dicdir``に用意しておくもの（``assignUserDictionaryCosts=true``の場合）

``matrix.bin``または``matrix.def``  
``dicrc``  
``left-id.def``  
``right-id.def``  

* ``dicdir``に用意しておくもの（``assignUserDictionaryCosts=false``の場合）

``matrix.bin``または``matrix.def``  
``dicrc``  
``left-id.def``  
``right-id.def``  
``pos-id.def``  

## ユーザー辞書を作成するには（自動コスト計算）

```
  //ユーザー辞書を作成する例（jumandic）

  //作業フォルダーを用意
$dictPath:=System folder(Desktop)+"jumandic-usr"+Folder separator
DELETE FOLDER($dictPath;Delete with contents)
CREATE FOLDER($dictPath;*)

  //CSVファイルを作成
C_COLLECTION($data)
$data:=New collection

  //1行目は空データにする（つぎの連結コストがマイナスにならないように）
$data.push(New collection("";0;0;0;"";"";"";"";"";"";""))

  //単語データは2行目以降に
$data.push(New collection("ルペック";1129;1129;0;"名詞";"地名";"*";"*";"ルペック";"ルペック";"*"))
$data.push(New collection("リバルディエール";1126;1126;0;"名詞";"人名";"*";"*";"リバルディエール";"リバルディエール";"*"))

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
  //設定ファイル（dicrc,matrix.bin,pos-id.def,rewrite.def,left-id.def,right-id.def）の場所
  //mecabのソースコードに含まれている設定ファイルはEUC-JPなので使用しない
$options.dicdir:=Get 4D folder(Current resources folder)+"jumandic"
$options.configCharset:="UTF-8"  //設定ファイルの文字コード
$options.dictionaryCharset:="UTF-8"  //入力CSVファイルの文字コード
  //出力DICファイルの文字コードはUTF-8固定

$options.assignUserDictionaryCosts:=True
$options.rewrite:=$options.dicdir+Folder separator+"rewrite.def"
$options.feature:=$options.dicdir+Folder separator+"feature.def"
$options.char:=$options.dicdir+Folder separator+"char.bin"
$options.model:=$options.dicdir+Folder separator+"model.bin"

  //コストの自動計算
$method:="mecab_progress"
MeCab INDEX DICTIONARY (JSON Stringify($options);$method)

MOVE DOCUMENT($dictPath+"data.csv";$dictPath+"data.txt")
MOVE DOCUMENT($options.userdic;$dictPath+"data.csv")

$options.assignUserDictionaryCosts:=True
$options.userdic:=$dictPath+"data.dic"

  //辞書ファイルの作成
MeCab INDEX DICTIONARY (JSON Stringify($options);$method)

  //システム辞書＋ユーザー辞書を使用
C_OBJECT($model)
$model:=New object
$model.dicdir:=Path to object(JSON Parse(MeCab Get model ).dicdir;Path is system).parentFolder+"jumandic"
$model.userdic:=$options.userdic

MeCab SET MODEL (JSON Stringify($model))
$model:=JSON Parse(MeCab Get model )
```

## ユーザー辞書を作成するには（モデル無し）

```
  //ユーザー辞書を作成する例（ipadic）

  //作業フォルダーを用意
$dictPath:=System folder(Desktop)+"ipadic-usr"+Folder separator
DELETE FOLDER($dictPath;Delete with contents)
CREATE FOLDER($dictPath;*)

  //CSVファイルを作成
C_COLLECTION($data)
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
  //設定ファイル（dicrc,matrix.bin,pos-id.def,rewrite.def,left-id.def,right-id.def）の場所
  //mecabのソースコードに含まれている設定ファイルはEUC-JPなので使用しない
$options.dicdir:=Get 4D folder(Current resources folder)+"ipadic"
$options.configCharset:="UTF-8"  //設定ファイルの文字コード
$options.dictionaryCharset:="UTF-8"  //入力CSVファイルの文字コード
  //出力DICファイルの文字コードはUTF-8固定

$options.assignUserDictionaryCosts:=False
$options.rewrite:=$options.dicdir+Folder separator+"rewrite.def"

  //辞書ファイルのコンパイル
$method:="mecab_progress"
MeCab INDEX DICTIONARY (JSON Stringify($options);$method)

  //システム辞書＋ユーザー辞書を使用
C_OBJECT($model)
$model:=New object
$model.dicdir:=Path to object(JSON Parse(MeCab Get model ).dicdir;Path is system).parentFolder+"ipadic"
$model.userdic:=$options.userdic
MeCab SET MODEL (JSON Stringify($model))
$model:=JSON Parse(MeCab Get model )
```
