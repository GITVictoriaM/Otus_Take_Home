variable "region" {
  type        = string
  default     = "eu-west-1"
  nullable = false
  description = "AWS region"
}
variable "admin_acct_arn" {
  type        = string
  default     = "arn:aws:iam::006871236038:user/EKS_Admin"
  nullable = false
  description = "Admin Account ARN"
}
variable "admin_acct_username" {
  type        = string
  default     = "EKS_Admin"
  nullable = false
  description = "Admin Account Username"
}