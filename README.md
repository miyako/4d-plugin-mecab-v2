# 4d-plugin-mecab-v2
4D implementation of [MeCab](http://taku910.github.io/mecab/)

### Platform

| carbon | cocoa | win32 | win64 |
|:------:|:-----:|:---------:|:---------:|
||<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|<img src="https://cloud.githubusercontent.com/assets/1725068/22371562/1b091f0a-e4db-11e6-8458-8653954a7cce.png" width="24" height="24" />|

__Mac version is now 64-bit only!__ 

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

辞書を切り替える例：

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
``userdic[]``: ユーザー辞書のファイルパス (``Path is system``)  

* ``userdic``は文字列またはコレクション

```
result:=MeCab (sentence)
```

Parameter|Type|Description
------------|------------|----
sentence|TEXT|sentence
result|TEXT|``JSON``

形態素分析の結果を返します。（下記オブジェクトのコレクション）

``feature``: コーパス  
``value``: 文字列  
``rcAttr``: 右文脈  
``lcAttr``: 左文脈  
``posid``: 形態素  
``char_type``: 文字種  
``stat``: 形態素種類  
``isbest``: 最適パス (``true`` ``false``)  

形態素の配列を取り出す例：

```
$sentence:="太郎は次郎が持っている本を花子に渡した。"

$result:=JSON Parse(MeCab ($sentence);Is collection)
$words:=$result.extract("value")
```

