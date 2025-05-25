variable "region" {
  type    = string
  default = "us-east-1"
}
variable "buckets" {
  description = "Map of bucket configurations"
  type = map(object({
    tags = map(string)
    policy = optional(string)
  }))
}
