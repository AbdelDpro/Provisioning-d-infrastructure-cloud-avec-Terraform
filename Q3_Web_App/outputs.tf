# --- 5. BONUS : Affiche l'URL à la fin ---
output "site_web_url" {
  value = "https://${azurerm_linux_web_app.mon_app.default_hostname}"
}