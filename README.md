# prototype_v1

Engineer Guild Hackathon 2025に向けて開発中のスマホ向けアプリケーション

# 開発環境

## APIキーの登録

このアプリではホットペッパーのAPIを使っているため、環境変数にAPIキーを入力する必要があります。
プロジェクトのルートに`.env`ファイルを作成し以下のように記述してください。

```
HOTPEPPER_API_KEY=j2eo32o**********
```

環境変数の設定が終わったら、次はパートファイルを作成します。

```
flutter pub run build_runner build
```

## 実行

```
flutter run 
```