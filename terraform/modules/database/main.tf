resource "aws_dynamodb_table" "document" {
  name           = var.document_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "document_id"

  attribute {
    name = "document_id"
    type = "S"
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "session" {
  name           = var.session_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "session_id"
  range_key      = "document_id"

  attribute {
    name = "session_id"
    type = "S"
  }
  attribute {
    name = "document_id"
    type = "S"
  }
  attribute {
    name = "expires_at"
    type = "N"
  }

  ttl {
    attribute_name = "expires_at"
    enabled        = true
  }

  global_secondary_index {
    name               = "document_id-index"
    hash_key           = "document_id"
    projection_type    = "ALL"
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "history" {
  name           = var.history_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "document_id"
  range_key      = "sequence_number"

  attribute {
    name = "document_id"
    type = "S"
  }
  attribute {
    name = "sequence_number"
    type = "N"
  }

  tags = var.tags
}
