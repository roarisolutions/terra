variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "resource_group_name_prefix" {
  description = "Prefix for the resource group names"
  type        = string
  default     = "rg-multi-vm-demo"
}

variable "vm_name_prefix" {
  description = "Prefix for the VM names"
  type        = string
  default     = "ubuntu-vm"
}

variable "vm_count" {
  description = "The number of VMs to create"
  type        = number
  default     = 3
}

variable "admin_username" {
  description = "The username for the VM administrator account"
  type        = string
  default     = "azureuser"
}

# You need to define a subnet ID in terraform.tfvars or use a data source to fetch an existing one.
variable "subnet_id" {
  description = "The ID of the subnet to place the VMs in"
  type        = string
  # No default value here, so you must specify it in terraform.tfvars
}
