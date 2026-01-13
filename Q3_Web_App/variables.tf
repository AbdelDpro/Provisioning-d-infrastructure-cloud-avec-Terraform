variable "rg_name" {
  description = "Le nom du Resource Group fourni par l'école"
  type        = string
  default     = "adaadiRG"  # On met ta valeur par défaut ici
}

variable "location" {
  description = "La région Azure"
  type        = string
  default     = "francecentral" # Ou la location de ton RG
}