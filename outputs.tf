# output "firewall_id" {
#   value = azurerm_firewall.this.id
# }

# output "firewall_name" {
#   value = azurerm_firewall.this.name
# }

# output "firewall_private_ip" {
#   value = azurerm_firewall.this.ip_configuration[0].private_ip_address
# }

# output "firewall_policy_id" {
#   value = azurerm_firewall_policy.this.id
# }

# output "firewall_policy_name" {
#   value = azurerm_firewall_policy.this.name
# }

# output "rule_collection_group_names" {
#   value = keys(azurerm_firewall_policy_rule_collection_group.this)
# }

# output "ip_group_ids" {
#   value = {
#     for k, v in azurerm_ip_group.this : k => v.id
#   }
# }