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