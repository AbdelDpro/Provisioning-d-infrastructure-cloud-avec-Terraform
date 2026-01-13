# --- 1. LE TERRAIN ---
data "azurerm_resource_group" "ecole_rg" {
  # !!! REMPLACE LE TEXTE CI-DESSOUS PAR LE NOM DE TON GROUPE !!!
  name = "adaadiRG"
}

# --- 2. LE RÉSEAU ---
resource "azurerm_virtual_network" "mon_vnet" {
  name                = "vnet-exercice"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.ecole_rg.location
  resource_group_name = data.azurerm_resource_group.ecole_rg.name
}

resource "azurerm_subnet" "mon_subnet" {
  name                 = "subnet-interne"
  resource_group_name  = data.azurerm_resource_group.ecole_rg.name
  virtual_network_name = azurerm_virtual_network.mon_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "ma_nic" {
  name                = "nic-ma-vm"
  location            = data.azurerm_resource_group.ecole_rg.location
  resource_group_name = data.azurerm_resource_group.ecole_rg.name

  ip_configuration {
    name                          = "config-interne"
    subnet_id                     = azurerm_subnet.mon_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# --- 3. LA VM (Version SSH) ---
resource "azurerm_linux_virtual_machine" "ma_vm" {
  name                = "vm-linux-etudiant"
  resource_group_name = data.azurerm_resource_group.ecole_rg.name
  location            = data.azurerm_resource_group.ecole_rg.location
  size                = "Standard_B1s"
  
  admin_username      = "adminuser"
  
  # Configuration SSH
  disable_password_authentication = true
  
  admin_ssh_key {
    username   = "adminuser"
    # On pointe vers le fichier public créé à l'étape 1 (.pub)
    public_key = file("~/.ssh/cle_exercice_azure.pub")
  }

  network_interface_ids = [
    azurerm_network_interface.ma_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}