# メシイク
#### 〜あいつの腹の内を知りたくない？〜
Engineer Guild Hackathon 2025に向けて開発中のスマホ向けアプリ  
# システム構成(2024-03-01)
![image](https://github.com/user-attachments/assets/266435ac-de05-4da5-b8e9-fbafd7ebb4ae)
# プロダクト、システム構成案(2025-03-01)
![image](https://github.com/user-attachments/assets/44ec741f-f8f7-4c4b-9e18-b733ef182aed)

# 開発環境
## バックエンドサーバーの用意
https://github.com/meshiiku/prototype_v1-server
## APIキーの登録
このアプリではホットペッパーのAPIを使っているため、環境変数にAPIキーを入力する必要があります。
プロジェクトのルートに`.env`ファイルを作成し以下のように記述してください。
```
HOTPEPPER_API_KEY=j2eo32o**********
BACKEND_BASEURL=http://localhost:3000
```
## 環境変数の設定
環境変数の設定が終わったら、次はパートファイルを作成します。
```
dart run build_runner build
```
## 実行
環境変数の用意が終わったら次はアプリの実行です、下記のコマンドで実行することができます。
```
flutter run 
```
