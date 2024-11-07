# Create Network Security Group and rules
resource "azurerm_network_security_group" "linux" {
  for_each            = { for i, vm in local.linux_vms : i => vm }
  name                = "nsg-${each.value.name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "windows" {
  for_each            = { for i, vm in local.windows_vms : i => vm }
  name                = "nsg-${each.value.name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "linux" {
  for_each                  = { for i, vm in local.linux_vms : i => vm }
  network_interface_id      = azurerm_network_interface.linux[each.key].id
  network_security_group_id = azurerm_network_security_group.linux[each.key].id
}

resource "azurerm_network_interface_security_group_association" "windows" {
  for_each                  = { for i, vm in local.windows_vms : i => vm }
  network_interface_id      = azurerm_network_interface.windows[each.key].id
  network_security_group_id = azurerm_network_security_group.windows[each.key].id
}
