# --- 1. LE LIEN AVEC L'EXISTANT ---
data "azurerm_resource_group" "ecole_rg" {
  # !!! REMPLACE LE TEXTE CI-DESSOUS PAR LE NOM DE TON GROUPE !!!
  name = "adaadiRG" 
}

# --- 2. GÉNÉRATEUR D'ID UNIQUE ---
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# --- 3. LE SERVICE PLAN (L'Infrastructure de l'Hôtel) ---
# C'est la "ferme de serveurs" qui va faire tourner ton application.
resource "azurerm_service_plan" "mon_plan" {
  name                = "plan-app-${random_string.suffix.result}"
  resource_group_name = data.azurerm_resource_group.ecole_rg.name
  location            = data.azurerm_resource_group.ecole_rg.location
  os_type             = "Linux"
  
  # SKU F1 = Free Tier (Gratuit). 
  # Si ça échoue (quota école atteint), remplace "F1" par "B1".
  sku_name            = "F1" 
}

# --- 4. LA WEB APP (Ta Chambre d'Hôtel) ---
resource "azurerm_linux_web_app" "mon_app" {
  name                = "app-data-${random_string.suffix.result}"
  resource_group_name = data.azurerm_resource_group.ecole_rg.name
  location            = data.azurerm_resource_group.ecole_rg.location
  service_plan_id     = azurerm_service_plan.mon_plan.id

  site_config {
    # On doit définir une "stack" même si c'est vide pour l'instant.
    # Ici, on dit qu'on est prêts à recevoir du Python (classique en Data).
    application_stack {
      python_version = "3.9"
    }
    # "always_on" doit être à false pour le plan Gratuit (F1)
    always_on = false
  }
}

