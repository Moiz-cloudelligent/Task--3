variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "moiz"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}