CommitBelt
====

結果にコミットするベルトを起動させるためのプログラムです。これで君も職場の人気者！？（※利用した際の周囲の反応にはコミットしません）  
元ネタ：[忘年会シーズン到来！結果にコミットするモノを作ってみた by @yamacho1111](http://tech.innovator.jp.net/entry/commit2016)

# Description

このプログラムはRaspberry Piのアタッチメントである[GrovePi](https://www.seeedstudio.com/GrovePi-p-1672.html)及び[Groveセンサ](https://www.seeedstudio.com/category/Grove-c-45.html)を活用するためのものです。  
GrovePiを利用するためには[GrovePiのGitHubリポジトリ](https://github.com/DexterInd/GrovePi)を利用する必要があります。  

このプログラムは以下の構成となっています。  

 - commit.rb : マグネットセンサの値を取得し、データポストするスクリプトです。ボタン操作などもこの中で扱います。
 - comfig-sample.yml : commit.rbを実行するために必要な設定情報を記載するファイルです。実際に使用する際にはconfig.ymlにリネームした上で設定値を記載して使ってください。
 - shell_grove_tilt.py : マグネットセンサの値を取得するためのスクリプトです。
 - shell_grove_button.py : ボタンの状態を取得するためのスクリプトです。
 - shell_grove_led.py : LEDのOn/Offを制御するためのスクリプトです。

# Release Note

- 2017.1.5: version1.0

# Usage

 `$ ruby commit.rb`  

停止は **Ctrl + C** です。

# SetUp

## GrovePi関連

参考：[GrovePi公式ページ](https://www.dexterindustries.com/GrovePi/get-started-with-the-grovepi/setting-software/)  
  
### 1.GitHub上のリポジトリをクローン  

Raspberry PiにSSHログインし、任意のディレクトリでレポジトリをクローンする  
  
`$ git clone htttps://github.com/DexterInd/GrovePi`
  
上記コマンドの結果、 **GrovePi** ディレクトリができていれば成功。

### 2.GrovePiライブラリをインストール

```
$ cd GrovePi/Script  
$ sudo chmod +x install.sh  
$ sudo ./install.sh
```

`./install.sh` の実行後、エンターキーを押下してください。  
途中で出てくる質問は全て **y** を押下してください。（デフォルトセッティングになります）
インストールが完了するとRESTARTと表示されるので、Raspberry PiのUSBケーブルを抜き差しして再起動してください。

### 3.GrovePiのPATH設定

GrovePiのライブラリを利用するためにPYTHONPATHの設定を行います。  
以下はRaspberry Piのpiユーザのホームディレクトリ（ */home/pi* ）直下にGrovePiをインストールした場合の例を示します。  

```
$ vim ~/.bash_profile
```

以下を末尾に記載して保存  

```
export PYTHONPATH="~/GrovePi/Software/Python:$PYTHONPATH"
```

## CommitBeltのダウンロード

Raspberry Pi上の任意のディレクトリで以下を実行します。  

`$ git clone https://github.com/iotfes/CommitBelt`

上記コマンドの結果、 **commitbelt** ディレクトリができていれば成功。

## Author

Akiyuki YOSHINO
