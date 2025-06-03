# outputs.tf for cache module

output "redis_cluster_id" {
  description = "The ID of the ElastiCache Redis cluster."
  value       = aws_elasticache_cluster.main.id
}

output "redis_primary_endpoint_address" {
  description = "The address of the primary endpoint for the ElastiCache Redis cluster."
  value       = aws_elasticache_cluster.main.cache_nodes[0].address
}

output "redis_cluster_engine" {
  description = "The engine of the ElastiCache cluster."
  value       = aws_elasticache_cluster.main.engine
}

output "redis_reader_endpoint_address" {
  description = "The address of the reader endpoint for the ElastiCache Redis cluster. May be null if not applicable (e.g. single node cluster)."
  value       = aws_elasticache_cluster.main.reader_endpoint_address
}
