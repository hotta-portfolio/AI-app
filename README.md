# 概要

未経験エンジニアが学習目的で作ったタスク管理アプリです。  
日々のタスクを整理・管理できる簡単なアプリです。

---

# アプリ URL / GitHub リポジトリ

- アプリURL: [https://taskmanager.example.com](https://taskmanager.example.com)  
- GitHubリポジトリ: [https://github.com/username/taskmanager](https://github.com/username/taskmanager)

---

## 作成目的

- React と Rails を使ったフルスタック開発を学習するため
- 認証機能や CRUD 操作を経験するため
- API通信やデータベース設計の理解を深めるため

---

## 主な機能

- ユーザー登録・ログイン・ログアウト（Devise 使用）
- タスクの作成・編集・削除
- タスクのカテゴリ分け・検索機能
- タスクのステータス管理（未完了・完了）
- レスポンシブデザイン対応（スマホ・PC）

---

## 技術スタック

- フロントエンド: React, TailwindCSS
- バックエンド: Ruby on Rails 8
- データベース: PostgreSQL
- 認証: Devise
- デプロイ: Render
- その他: Axios, Redux Toolkit

---

## データ構造・ER図

アプリのデータベース構造を示します。

![ER図](./screenshots/er_diagram.png)

### 補足
- `users` テーブル: アプリ利用者情報
- `tasks` テーブル: ユーザーのタスク情報（user_id が外部キー）
- `categories` テーブル: タスクのカテゴリ
- 1人のユーザーは複数のタスクを持つ (1:N)
- タスクは 1 つのカテゴリに所属 (N:1)

---

## 学んだこと・今後の改善

- フルスタック開発（フロント・バックエンド）の理解を深めた
- 認証・CRUD操作・API連携の基礎を経験
- 今後の改善点：
  - テストコードの追加（RSpec / Jest）
  - UI/UX改善（ドラッグ＆ドロップでタスク順番変更など）
  - CI/CD の導入
