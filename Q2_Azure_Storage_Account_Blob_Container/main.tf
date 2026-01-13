# --- 1. LE LIEN AVEC L'EXISTANT ---
data "azurerm_resource_group" "ecole_rg" {
  # Ton Resource Group
  name = "adaadiRG" 
}

# --- 2. LE GÉNÉRATEUR DE NOM (Pour éviter les erreurs) ---
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# --- 3. LE COMPTE DE STOCKAGE (L'entrepôt) ---
resource "azurerm_storage_account" "mon_stockage" {
  # Le nom sera "st" + des lettres au hasard (ex: stxy78k)
  name                     = "st${random_string.suffix.result}"
  resource_group_name      = data.azurerm_resource_group.ecole_rg.name
  location                 = data.azurerm_resource_group.ecole_rg.location
  
  # Configuration standard demandée
  account_tier             = "Standard"
  account_replication_type = "LRS" # Local Redundancy (le moins cher)

  tags = {
    environment = "Exercice-Data-Engineer"
  }
}

# --- 4. LE CONTENEUR (Le dossier interne) ---
resource "azurerm_storage_container" "mon_container" {
  name                  = "data-raw" # Nom du conteneur demandé
  storage_account_name  = azurerm_storage_account.mon_stockage.name
  container_access_type = "private" # Accès privé par sécurité
}