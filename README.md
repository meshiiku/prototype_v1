# メシイク！？(Engineer Guild Hackathon 2025)
## 〜あいつの腹の内知りたくない？〜
⁩素直に”ご飯に行こう”と言い出せないあなたへ、気軽にメシに誘えるアプリの開発を目指しています！
#### スクショ
<p>
  <img src="https://github.com/user-attachments/assets/858cf6a9-c745-4774-bf80-5446580657ee" width="40%">
  <img src="https://github.com/user-attachments/assets/e5fc2844-b989-4885-ba7c-cb7908deec5f" width="40%">
  <img src="https://github.com/user-attachments/assets/b8514013-b7ee-409e-9149-b7270ee1613d" width="40%">
  <img src="https://github.com/user-attachments/assets/a2b64f33-5899-4339-9df0-48973d9bd033" width="40%">
</p>

# 現在のシステム構成(2024-03-01)
- こちらはプロトタイプのシステム構成となっています。

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
