
# Terraform Project: Provisioning Linux and Windows Virtual Machines on Azure

This Terraform project automates the provisioning of Linux and Windows virtual machines (VMs) on Microsoft Azure. It includes adjacent resources such as Network Security Groups (NSGs), Virtual Network (VNet), Subnets, Public IPs, and Network Interfaces, ensuring each VM is securely connected and accessible.

## Project Structure

This project creates the following Azure resources:
- **Virtual Network (VNet)**: A private network to securely host the VMs.
- **Subnets**: Divides the VNet into smaller, manageable sections.
- **Network Security Groups (NSGs)**: Controls inbound and outbound traffic to the VMs.
  - Configured for SSH (Linux VMs) and RDP (Windows VMs) access.
- **Public IPs**: Provides public internet access to each VM.
- **Network Interfaces**: Connects VMs to the network.
- **Linux and Windows Virtual Machines**: Configures VMs with custom specifications, including Spot instance options for cost efficiency.

## Prerequisites

Ensure you have the following installed:
- [Terraform](https://www.terraform.io/downloads.html) (v1.0 or higher)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) for authentication

Additionally, log into Azure using the CLI before running Terraform:
```bash
az login
```

## Usage

1.	Clone the repository:
git clone https://github.com/rhoribe/azure-virtual-machine.git

cd azure-virtual-machine

2. Customize Variables:

Edit the variables.tf or provide a environment/dev.tfvars file .

3. Initialize the Terraform project:

terraform init

4. Terraform  plan

terraform plan -var-file=environment/dev.tfvars

5. Terraform apply

terraform plan -var-file=environment/dev.tfvars -y

6.	Review Outputs:

After the apply is complete, Terraform will output information about the created resources, including VM IDs, network interface IDs, and public IP addresses.

## Example Configuration
```hlc
rg_name                 = "test"
rg_location             = "East US"
vnet_name               = "test"
vnet_address_space      = ["10.0.0.0/16"]
subnet_name             = "test"
subnet_address_prefixes = ["10.0.1.0/24"]
subscription_id         = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
tenant_id               =  "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
vm = [
  {
    create         = true
    os             = "linux"
    name           = "vm-linux"
    size           = "Standard_DC2s_v2"
    admin_username = "azureuser"
    priority        = "Spot"
    eviction_policy = "Delete"
    max_bid_price   = "-1"
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "19_10-daily-gen2"
      version   = "latest"
    }
  },
  {
    create          = false
    os              = "windows"
    name            = "vm-windows"
    size            = "Standard_DC2s_v2"
    admin_username  = "azureuser"
    admin_password  = "uR3_wer#5429hy$"
    priority        = "Spot"
    eviction_policy = "Delete"
    max_bid_price   = "-1"
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition"
      version   = "latest"
    }
  }
]
```


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.8.0 |


## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_windows_virtual_machine.windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_rg_location"></a> [rg\_location](#input\_rg\_location) | The Azure region where the resource group and its resources will be located. | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group where the resources will be created. | `string` | n/a | yes |
| <a name="input_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#input\_subnet\_address\_prefixes) | The address prefixes for the subnet, defined as a list of CIDR blocks. | `list(string)` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet within the Virtual Network (VNet). | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The subscription ID for the Azure account where the resources will be created. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The tenant ID for the Azure Active Directory associated with the subscription. | `string` | n/a | yes |
| <a name="input_vm"></a> [vm](#input\_vm) | A list of virtual machine configurations, each with details on OS, name, size, admin account, OS disk, and image source. | <pre>list(object({<br/>    create          = optional(bool, false)<br/>    os              = optional(string, "Linux")<br/>    name            = optional(string, "my-vm")<br/>    size            = optional(string, "Standard_DC1s_v2")<br/>    admin_username  = optional(string, "azureuser")<br/>    admin_password  = optional(string, "")<br/>    priority        = optional(string, null)<br/>    eviction_policy = optional(string, null)<br/>    max_bid_price   = optional(string, -1)<br/>    os_disk = object({<br/>      caching              = optional(string, "ReadWrite")<br/>      storage_account_type = optional(string, "Standard_LRS")<br/>    })<br/>    source_image_reference = object({<br/>      publisher = optional(string, "Canonical")<br/>      offer     = optional(string, "UbuntuServer")<br/>      sku       = optional(string, "19_10-daily-gen2")<br/>      version   = optional(string, "latest")<br/>    })<br/>  }))</pre> | n/a | yes |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space for the Virtual Network (VNet), defined as a list of CIDR blocks. | `list(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name of the Virtual Network (VNet) that will be created or used. | `string` | n/a | yes |