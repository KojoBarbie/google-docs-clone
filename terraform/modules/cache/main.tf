# main.tf for cache module

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-cache-subnet-group"
  subnet_ids = var.private_subnet_ids # This will come from the network module

  tags = {
    Name        = "${var.project_name}-${var.environment}-cache-subnet-group"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${var.project_name}-${var.environment}-redis-cluster"
  engine               = "redis"
  node_type            = var.cache_node_type
  num_cache_nodes      = var.cache_num_nodes
  engine_version       = var.cache_engine_version
  parameter_group_name = var.cache_parameter_group_name
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = var.cache_security_group_ids # This will likely include the main_security_group_id from the network module

  tags = {
    Name        = "${var.project_name}-${var.environment}-redis-cluster"
    Project     = var.project_name
    Environment = var.environment
  }
}
