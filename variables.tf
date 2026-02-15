variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "The machine type for the VM instances"
  type        = string
  default     = "e2-micro"
}

variable "instance_count" {
  description = "The number of VM instances to create"
  type        = number
  default     = 3
}
