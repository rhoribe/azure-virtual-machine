
### Linux
resource "azurerm_linux_virtual_machine" "linux" {
  for_each            = { for i, vm in local.linux_vms : i => vm }
  name                = each.value.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = each.value.size
  admin_username      = each.value.admin_username

  network_interface_ids = [azurerm_network_interface.linux[each.key].id]

  priority        = each.value.priority
  eviction_policy = each.value.eviction_policy
  max_bid_price   = each.value.max_bid_price

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }
}


##$ Windows 
resource "azurerm_windows_virtual_machine" "windows" {
  for_each            = { for i, vm in local.windows_vms : i => vm }
  name                = each.value.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = each.value.size
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password

  network_interface_ids = [azurerm_network_interface.windows[each.key].id]

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  # Optional Windows custom data, for example to set up scripts
  # os_profile_windows_config {
  #   provision_vm_agent        = true
  #   enable_automatic_updates  = true
  # }
}