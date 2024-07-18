variable "addons" {
  description = "addons"
  type        = any
}

variable "workloads" {
  description = "workloads"
  type        = any
}

variable "administrations" {
  description = "administrations"
  type        = any
}

variable "env" {
  description = "value"
  type        = string
  nullable    = false
}
