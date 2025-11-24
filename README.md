# 概要

AIの生成ノウハウを売買して共有できるアプリ

---

# アプリ URL / GitHub リポジトリ

- アプリURL: [https://taskmanager.example.com](https://taskmanager.example.com)  
- GitHubリポジトリ: [https://github.com/username/taskmanager](https://github.com/username/taskmanager)

---

## 作成目的

- StripeやActioncableといった商用に関連性の高いRailsの機能を用いて、開発を学習するため
- API通信やデータベース設計の理解を深めるため
- rspecのテスト構造の理解を深めるため
---

## 主な機能

- ユーザー登録・ログイン・ログアウト（Devise 使用）
- コンテンツの新規投稿機能 (Javascriptを使用　STEP1とSTEP2でページ区分やファイルアップロード時のプレビュー表示など)
- コンテンツのカテゴリ・タグ・価格帯別検索機能 (Ransack 使用)
- コンテンツのカード擬似決済機能 (Stripe 使用)
- チャット機能 (ActionCable使用)

![機能説明](./app/assets/images/Feature%20Description/Feature%20Description.png)

---

## 技術スタック

- Rails 8 アプリ
  - フロントエンド: JavaScript / Bootstrap / Turbo
  - 認証: Devise
- データベース: PostgreSQL
- 開発環境: Docker Compose
- デプロイ: Render
- CI/CD: GitHub Actions
  - rubocop と rspec が pass したら自動で Render にデプロイ
- 画像・動画管理: Cloudinary（本番環境のみ）

---

## データ構造・ER図

アプリのデータベース構造を示します。

![ER図](./app/assets/images/README_image/Entity%20Relationship%20Diagram.png)

### 補足
- users テーブル: アプリ利用者情報
- knowhows テーブル: 投稿されたコンテンツ情報
- instructions テーブル: コンテンツ(生成ノウハウ)の生成手順情報
- payments テーブル:　決済用カード情報


---

## 学んだこと・今後の改善

- フルスタック開発（フロント・バックエンド）の理解を深めた
- 認証・CRUD操作・API連携の基礎を経験
- 今後の改善点：
  - DRYを意識したコード設計(現状が冗長的で生産的でない)
  - 本番環境のみ(Render)、チャット送信直後に、チャット一覧にメッセージが表示されずリロードしないと反映されないためため、改善を図る
