resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_public_ip" "linux" {
  for_each            = { for i, vm in local.linux_vms : i => vm }
  name                = "public-ip-${each.value.name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_public_ip" "windows" {
  for_each            = { for i, vm in local.windows_vms : i => vm }
  name                = "public-ip-${each.value.name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}


resource "azurerm_network_interface" "linux" {
  for_each            = { for i, vm in local.linux_vms : i => vm }
  name                = "nic-${each.value.name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "ipconfig-${each.value.name}"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux[each.key].id

  }
}

resource "azurerm_network_interface" "windows" {
  for_each            = { for i, vm in local.windows_vms : i => vm }
  name                = "nic-${each.value.name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "ipconfig-${each.value.name}"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows[each.key].id

  }
}