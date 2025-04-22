# GoogleDocsクローン AWS インフラストラクチャ

このディレクトリには、GoogleDocsクローンアプリケーションのバックエンドインフラストラクチャをAWS上に構築するためのTerraformコードが含まれています。フロントエンドはVercelでホスティングされることを前提としています。

## アーキテクチャ概要

このインフラストラクチャは、リアルタイム協調編集機能を持つドキュメントエディタを実現するために、以下のAWSサービスを活用します：

- **API Gateway**: REST APIとWebSocket APIの提供
- **Lambda**: サーバーレスバックエンド処理
- **DynamoDB**: ドキュメント、セッション、操作履歴の保存
- **ElastiCache (Redis)**: リアルタイムセッション管理とキャッシュ
- **VPC**: プライベートネットワーク環境の提供

## ディレクトリ構造

```
terraform/
├── main.tf           # メインの設定ファイル（モジュール呼び出し）
├── variables.tf      # 変数定義
├── outputs.tf        # 出力値
├── providers.tf      # プロバイダ設定
├── backend.tf        # 状態管理設定
└── modules/
    ├── api/          # API Gateway + Lambda モジュール
    │   ├── main.tf   # REST API、WebSocket API両方を管理
    │   ├── variables.tf
    │   └── outputs.tf
    ├── database/     # DynamoDBモジュール
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── cache/        # ElastiCacheモジュール
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── network/      # VPC関連モジュール
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## モジュール説明

### API モジュール (modules/api/)

RESTful APIとWebSocket APIの両方を提供し、リアルタイム編集機能を実現します。

**提供リソース**:
- REST API Gateway
- WebSocket API Gateway
- ドキュメント操作Lambda関数
- セッション管理Lambda関数
- リアルタイム同期Lambda関数
- OT (Operational Transformation) 実装Lambda関数

**主要なエンドポイント**:
- REST: ドキュメント作成、取得、セッション管理
- WebSocket: リアルタイム編集データ同期、カーソル位置同期

### データベース モジュール (modules/database/)

アプリケーションのデータを保存するDynamoDBテーブルを提供します。

**提供リソース**:
- ドキュメントテーブル: `document_id`をパーティションキーとして使用
- セッションテーブル: `session_id`をパーティションキー、`document_id`をソートキーとして使用
- 操作履歴テーブル: `document_id`をパーティションキー、`sequence_number`をソートキーとして使用

**特徴**:
- オンデマンドキャパシティモードでの柔軟なスケーリング
- セッションテーブルでのTTL（有効期限）設定
- 効率的なクエリのためのグローバルセカンダリインデックス

### キャッシュ モジュール (modules/cache/)

リアルタイムセッション管理とパフォーマンス向上のためのRedisキャッシュを提供します。

**提供リソース**:
- ElastiCache (Redis) クラスター
- Redis用サブネットグループ

**主な用途**:
- アクティブセッション情報の一時保存
- 操作キューの一時保存
- WebSocket接続状態の管理

### ネットワーク モジュール (modules/network/)

セキュアなネットワーク環境を提供します。

**提供リソース**:
- VPC
- プライベートサブネット (ElastiCache用)
- パブリックサブネット (Lambda VPC統合用)
- セキュリティグループ
- VPCエンドポイント (DynamoDB, S3用)

## デプロイ手順

1. AWSアクセスキーと秘密キーを設定します:
   ```bash
   export AWS_ACCESS_KEY_ID="your_access_key"
   export AWS_SECRET_ACCESS_KEY="your_secret_key"
   export AWS_DEFAULT_REGION="ap-northeast-1"  # 東京リージョンの例
   ```

2. Terraformの初期化を行います:
   ```bash
   terraform init
   ```

3. 実行計画を確認します:
   ```bash
   terraform plan
   ```

4. インフラストラクチャをデプロイします:
   ```bash
   terraform apply
   ```

5. デプロイが完了すると、API URLなどの重要な情報が出力されます。

## セキュリティとパフォーマンスの考慮事項

### セキュリティ
- 最小権限の原則に基づいたIAMポリシー
- VPC内でのリソース配置
- セキュリティグループによるアクセス制御
- API Gatewayでの認証設定

### パフォーマンス
- DynamoDBのオンデマンドキャパシティモード
- ElastiCacheの適切なインスタンスサイズ選択
- Lambda関数の適切なメモリ割り当て
- CloudWatch Alarmによるモニタリング

## OT（Operational Transformation）実装

このインフラストラクチャは、複数ユーザー間の同時編集を可能にするOT（Operational Transformation）アルゴリズムの実装をサポートします。

- Lambda関数での変換処理
- DynamoDBでの操作履歴保存
- ElastiCacheでのリアルタイム状態同期

## ユースケース

1. **ドキュメント作成**:
   - ユーザーが新規ドキュメントを作成
   - DynamoDBにドキュメントメタデータと初期コンテンツが保存
   - 編集用と閲覧用のリンクが生成

2. **リアルタイム協調編集**:
   - 複数ユーザーが同じドキュメントを同時編集
   - WebSocketを通じて編集内容がリアルタイムに同期
   - OTアルゴリズムで編集競合を解決

3. **セッション管理**:
   - 各ユーザーのセッション情報がElastiCacheとDynamoDBで管理
   - カーソル位置と選択状態がリアルタイムに表示
   - 非アクティブセッションは自動的に期限切れ

## コスト最適化

- Lambda関数のタイムアウトと割り当てメモリの最適化
- DynamoDBのオンデマンドモードによる使用量に基づく課金
- ElastiCacheの適切なインスタンスサイズ選択
- CloudWatch Logsの保持期間設定
