output "document_table_name" {
  value = aws_dynamodb_table.document.name
}

output "document_table_arn" {
  value = aws_dynamodb_table.document.arn
}

output "session_table_name" {
  value = aws_dynamodb_table.session.name
}

output "session_table_arn" {
  value = aws_dynamodb_table.session.arn
}

output "history_table_name" {
  value = aws_dynamodb_table.history.name
}

output "history_table_arn" {
  value = aws_dynamodb_table.history.arn
}
