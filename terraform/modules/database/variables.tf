variable "document_table_name" {
  description = "ドキュメントテーブル名"
  type        = string
  default     = "docs_documents"
}

variable "session_table_name" {
  description = "セッションテーブル名"
  type        = string
  default     = "docs_sessions"
}

variable "history_table_name" {
  description = "操作履歴テーブル名"
  type        = string
  default     = "docs_history"
}

variable "tags" {
  description = "DynamoDBテーブル共通タグ"
  type        = map(string)
  default     = {}
}
