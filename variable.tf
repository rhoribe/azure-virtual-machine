variable "rg_name" {
  type        = string
  description = "The name of the resource group where the resources will be created."
}

variable "rg_location" {
  type        = string
  description = "The Azure region where the resource group and its resources will be located."
}

variable "vnet_name" {
  type        = string
  description = "The name of the Virtual Network (VNet) that will be created or used."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "The address space for the Virtual Network (VNet), defined as a list of CIDR blocks."
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet within the Virtual Network (VNet)."
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "The address prefixes for the subnet, defined as a list of CIDR blocks."
}

variable "subscription_id" {
  type        = string
  description = "The subscription ID for the Azure account where the resources will be created."

  validation {
    condition     = length(var.subscription_id) == 36 && can(regex("^([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}$", var.subscription_id))
    error_message = "The 'subscription_id' must be a valid Azure subscription UUID."
  }
}

variable "tenant_id" {
  type        = string
  description = "The tenant ID for the Azure Active Directory associated with the subscription."

  validation {
    condition     = length(var.tenant_id) == 36 && can(regex("^([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}$", var.tenant_id))
    error_message = "The 'tenant_id' must be a valid Azure tenant UUID."
  }
}

variable "vm" {
  type = list(object({
    create          = optional(bool, false)
    os              = optional(string, "Linux")
    name            = optional(string, "my-vm")
    size            = optional(string, "Standard_DC1s_v2")
    admin_username  = optional(string, "azureuser")
    admin_password  = optional(string, "")
    priority        = optional(string, null)
    eviction_policy = optional(string, null)
    max_bid_price   = optional(string, -1)
    os_disk = object({
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "Standard_LRS")
    })
    source_image_reference = object({
      publisher = optional(string, "Canonical")
      offer     = optional(string, "UbuntuServer")
      sku       = optional(string, "19_10-daily-gen2")
      version   = optional(string, "latest")
    })
  }))
  description = "A list of virtual machine configurations, each with details on OS, name, size, admin account, OS disk, and image source."
  validation {
    condition     = alltrue([for vm in var.vm : lower(vm.os) == "linux" || lower(vm.os) == "windows"])
    error_message = "The 'os' field must be either 'linux' or 'windows'."
  }
  validation {
    condition     = alltrue([for vm in var.vm : vm.create == true || vm.create == false])
    error_message = "The 'create' field must be true or false."
  }
  validation {
    condition     = alltrue([for vm in var.vm : vm.priority == "Spot" || vm.priority == "Regular" || vm.priority == null])
    error_message = "The 'vm.priority' field must be Spot or Regular."
  }
  validation {
    condition     = alltrue([for vm in var.vm : vm.eviction_policy == "Deallocate" || vm.eviction_policy == "Delete" || vm.eviction_policy == null])
    error_message = "The 'vm.eviction_policy' field must be Deallocate or  Delete."
  }
}