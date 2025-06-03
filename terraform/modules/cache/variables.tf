# variables.tf for cache module

variable "project_name" {
  description = "Project name for tagging resources."
  type        = string
  default     = "my-project"
}

variable "environment" {
  description = "Environment name for tagging resources (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where the ElastiCache cluster will be deployed."
  type        = list(string)
  # No default, this must be provided from the network module.
}

variable "cache_security_group_ids" {
  description = "List of security group IDs for the ElastiCache cluster."
  type        = list(string)
  # No default, this must be provided (likely from the network module).
}

variable "cache_node_type" {
  description = "Node type for the ElastiCache cluster (e.g., cache.t3.micro)."
  type        = string
  default     = "cache.t3.micro"
}

variable "cache_num_nodes" {
  description = "Number of nodes in the ElastiCache cluster."
  type        = number
  default     = 1
}

variable "cache_engine_version" {
  description = "Engine version for the ElastiCache cluster (e.g., '6.x')."
  type        = string
  default     = "6.x"
}

variable "cache_parameter_group_name" {
  description = "Parameter group name for the ElastiCache cluster (e.g., 'default.redis6.x')."
  type        = string
  default     = "default.redis6.x"
}
