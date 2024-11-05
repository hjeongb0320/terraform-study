resource "azurerm_linux_virtual_machine" "virtual_machine" {
  name                  = var.resource_label
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.network_interface.id]
  admin_username        = var.resource_label
  size                  = "Standard_B1s"
  zone                  = "1"

  admin_ssh_key {
    username   = var.resource_label
    public_key = file("~/.ssh/id_rsa.pub")
  }

  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  secure_boot_enabled = true
  vtpm_enabled        = true
}

resource "azurerm_ssh_public_key" "vm_ssh_key" {
  name                = var.resource_label
  resource_group_name = var.resource_group_name
  location            = var.location
  public_key          = file("~/.ssh/id_rsa.pub")
}

resource "azurerm_network_interface" "network_interface" {
  name                = var.resource_label
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = var.resource_label
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "network_security_group" {
  name                = var.resource_label
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface_security_group_association" "network_interface_sercurity_group_association" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.network_security_group.id
}

resource "azurerm_network_security_rule" "http_rule" {
  name                        = "HTTP"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.network_security_group.name
}

resource "azurerm_network_security_rule" "https_rule" {
  name                        = "HTTPS"
  priority                    = 320
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.network_security_group.name
}

resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "SSH"
  priority                    = 340
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.network_security_group.name
}

resource "azurerm_virtual_machine_extension" "aad_ssh_login" {
  name                 = "AADSSHLoginForLinux"
  virtual_machine_id   = azurerm_linux_virtual_machine.virtual_machine.id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADSSHLoginForLinux"
  type_handler_version = "1.0"
}

resource "azurerm_virtual_machine_extension" "vm_access_for_linux" {
  name                 = "enablevmAccess"
  virtual_machine_id   = azurerm_linux_virtual_machine.virtual_machine.id
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "VMAccessForLinux"
  type_handler_version = "1.5"

  protected_settings = jsonencode({
    username = var.resource_label
    ssh_key  = file("~/.ssh/id_rsa.pub")
  })
}

