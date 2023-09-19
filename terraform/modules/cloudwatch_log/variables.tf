variable "prefix" {
  description = "Prefix for Resources eg. myaccount-prod"
}
variable "tags" {
  description = "Custom tags on aws resources"
  type        = map(any)
  default     = null
}