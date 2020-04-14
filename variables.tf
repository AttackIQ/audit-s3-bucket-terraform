variable "monitored_bucket" {
  type        = string
  description = "Name of the bucket to monitor"
  default = "cg-cardholder-data-bucket-cgidlulwjvrwio"
}

variable "name" {
  type        = string
  default     = "aiq"
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

