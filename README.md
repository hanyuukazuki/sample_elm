# Simple VR with Elm and A-Frame

## Getting started

1.https://nodejs.org/ja/download/にアクセスし、windows用のNode.jsインストーラをダウンロードしてください。

2.インストーラを実行し、Node.jsをインストールしてください。

3.https://github.com/elm/compiler/releases/download/0.19.0/installer-for-windows.exeにアクセスし、
 Elmのインストーラをダウンロードしてください。
 
4.インストーラを実行し、Elmをインストールしてください。

5.コントロールパネルを開き、システムとセキュリティ→システム→システムの詳細設定→環境変数の順にクリックし、
 環境変数設定画面を呼び出してください。
 
6.システム環境変数のPathの値をダブルクリックし、開いた画面に下記の行が存在していることを確認してください。
 また、存在していない場合には追加を行ってください。
  
  C:\Program Files\nodejs\
  
  C:\Program Files (x86)\Elm\0.19\bin
  
7.elm-aframe-masterディレクトリを、Cドライブ直下にコピーしてください。

8.コマンドプロンプトを起動し、下記のコマンドを一行ずつ入力し実行してください。
  
  cd C:\elm-aframe-example-master\2_walk
  
  npm install
  
  elm init
  
  Yes 選択
  
  npm run start

9.[http://localhost:8080](http://localhost:8080)にアクセスし、プログラムの動作をご確認ください。
