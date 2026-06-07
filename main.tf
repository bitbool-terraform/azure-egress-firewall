resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group

  allocation_method = "Static"
  sku               = "Standard"
  zones             = var.pip_zones
  ip_tags                 = {}
  tags = var.tags
}

resource "azurerm_firewall" "fw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group

  sku_name = var.sku_name
  sku_tier = var.sku_tier
  zones    = var.zones

  firewall_policy_id = azurerm_firewall_policy.fw_policy.id

  ip_configuration {
    name                 = "${var.resource_group}-FW-PIP01"
    subnet_id            = var.azure_firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  tags = var.tags
}

resource "azurerm_firewall_policy" "fw_policy" {
  name                = format("%sfwpolicy01",lower(replace(var.resource_group,"-","")))
  location            = var.location
  resource_group_name = var.resource_group
  sku                      = var.sku_tier
  dns {
      proxy_enabled = true
      servers       = []
    }
  tags = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  for_each = var.rule_collection_groups

  name               = each.key
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = each.value.priority

  dynamic "network_rule_collection" {
    for_each = each.value.network_rule_collections

    content {
      name     = network_rule_collection.key
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules

        content {
          name                  = rule.key
          protocols             = rule.value.protocols
          destination_ports     = rule.value.destination_ports

          source_addresses = length(rule.value.source_addresses) > 0 ? rule.value.source_addresses : null

          destination_addresses = length(rule.value.destination_addresses) > 0 ? rule.value.destination_addresses : null
          destination_fqdns     = length(rule.value.destination_fqdns) > 0 ? rule.value.destination_fqdns : null
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = each.value.application_rule_collections

    content {
      name     = application_rule_collection.key
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules

        content {
          name        = rule.key
          description = rule.value.description

          source_addresses = length(rule.value.source_addresses) > 0 ? rule.value.source_addresses : null

          destination_fqdns     = length(rule.value.destination_fqdns) > 0 ? rule.value.destination_fqdns : null
          destination_fqdn_tags = length(rule.value.destination_fqdn_tags) > 0 ? rule.value.destination_fqdn_tags : null
          web_categories        = length(rule.value.web_categories) > 0 ? rule.value.web_categories : null

          terminate_tls = rule.value.terminate_tls

          dynamic "protocols" {
            for_each = rule.value.protocols

            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }
}
