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

### 辞書

```
  //辞書を切り替える例
  
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

形態素の配列を取り出す例：

```
$sentence:="太郎は次郎が持っている本を花子に渡した。"

$result:=JSON Parse(MeCab($sentence);Is collection)
$words:=$result.extract("value")
```

### ユーザー辞書

```
  //ユーザー辞書を作成する例

  //作業フォルダーを用意
$dictPath:=System folder(Desktop)+"test-dict"+Folder separator
DELETE FOLDER($dictPath;Delete with contents)
CREATE FOLDER($dictPath;*)

  //CSVファイルを作成
C_COLLECTION($data)
$data:=New collection

  //1行目は空データにする
$data.push(New collection("";0;0;0;"*";"*";"*";"*";"*";"*";"";"";""))

  //単語データは2行目以降に
$data.push(New collection("ルペック";1293;1293;1;"名詞";"固有名詞";"地域";"一般";"*";"*";"ルペック";"ルペック";"ルペック"))
$data.push(New collection("リバルディエール";1291;1291;1;"名詞";"固有名詞";"人名";"名";"*";"*";"リバルディエール";"リバルディエール";"リバルディエール"))

$csv:=New collection
For each ($datum;$data)
	$csv.push($datum.join(","))
End for each 
  //改行コードはLFで
TEXT TO DOCUMENT($dictPath+"names.csv";$csv.join("\n");"utf-8";Document unchanged)

  //辞書データの設定
C_OBJECT($options)
$options:=New object
  //出力DICファイルパス
$options.userdic:=$dictPath+"test.dic"
  //入力CSVファイルのフォルダーパス
$options.userdicdir:=$dictPath
  //設定ファイル（dicrc,matrix.bin,pos-id.def,rewrite.def,left-id.def,right-id.def）の場所
  //mecabのソースコードに含まれている設定ファイルはEUC-JPなので使用しない
$options.dicdir:=Get 4D folder(Current resources folder)+"ipadic"
$options.configCharset:="UTF-8"  //設定ファイルの文字コード
$options.dictionaryCharset:="UTF-8"  //入力CSVファイルの文字コード
  //出力DICファイルの文字コードはUTF-8固定

  //辞書ファイルのコンパイル
$method:="mecab_progress"
MeCab INDEX DICTIONARY (JSON Stringify($options);$method)

  //システム辞書＋ユーザー辞書を使用
C_OBJECT($model)
$model:=New object
$model.dicdir:=Path to object(JSON Parse(MeCab Get model ).dicdir;Path is system).parentFolder+"ipadic"
$model.userdic:=System folder(Desktop)+"test-dict"+Folder separator+"test.dic"
MeCab SET MODEL (JSON Stringify($model))
$model:=JSON Parse(MeCab Get model )
```

<img width="800" alt="2018-12-17 10 00 59" src="https://user-images.githubusercontent.com/1725068/50061348-ce7c4c80-01e2-11e9-9443-8f29f0ffee17.png">

### N-best

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
``options.dicdir``: 設定ファイル  

* 任意プロパティ

``options.configCharset``: 設定ファイルの文字コード（既定：``EUC-JP``）  
``options.dictionaryCharset``: 入力CSVファイルの文字コード（既定：``EUC-JP``）  

出力ファイルの文字コードはUTF-8固定です。

``options.buildUnknown``: ``unk.dic``を出力（既定：``false``）  
``options.buildMatrix``: ``matrix.bin``を出力（既定：``false``）  
``options.buildCharCategory``: ``char.bin``を出力（既定：``false``）  
``options.buildSysdic``: ``sys.dic``を出力（既定：``true``）   
``options.buildModel``: ``model.bin``を出力（既定：``false``; ``model.def``が``dicdir``に無ければ無視）  

## ユーザー辞書を作成するには

* 必須プロパティ

``options.userdic``: 出力ファイルパス  
``options.userdicdir``: 入力フォルダーパス（CSVファイルの場所）  
``options.dicdir``: 設定ファイル  

* 任意プロパティ

``options.assignUserDictionaryCosts``: （``feature.def``ファイルが``dicdir``に無ければ無視）  
