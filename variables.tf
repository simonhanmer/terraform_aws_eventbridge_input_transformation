variable "region" {
  type        = string
  description = "which region to deploy infra to"
  default     = "eu-west-1"
}

variable "project_name" {
  type        = string
  description = "Name of project, used to build resource names"
  default     = "eventbridge-transformer-simon"
}
