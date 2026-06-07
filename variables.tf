variable "name" {
  type        = string
}

variable "location" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "public_ip_name" {
  type    = string
  default = null
}

variable "azure_firewall_subnet_id" {
  type        = string
}

variable "sku_tier" {
  type        = string
  default     = "Standard"
}
variable "sku_name" {
  type        = string
  default     = "AZFW_VNet"
}

variable "zones" {
  type        = list(string)
  default     = null
}
variable "pip_zones" {
  type        = list(string)
  default     = ["1","2","3"]
}

variable "rule_collection_groups" {
  type = map(object({
    priority = number

    network_rule_collections = optional(map(object({
      priority = number
      action   = string

      rules = map(object({
        protocols         = list(string)
        destination_ports = list(string)

        source_addresses     = optional(list(string), [])
        source_ip_group_keys = optional(list(string), [])
        source_ip_group_ids  = optional(list(string), [])

        destination_addresses = optional(list(string), [])
        destination_fqdns     = optional(list(string), [])
        destination_ip_groups = optional(list(string), [])
      }))
    })), {})

    application_rule_collections = optional(map(object({
      priority = number
      action   = string

      rules = map(object({
        description = optional(string, null)

        source_addresses     = optional(list(string), [])
        source_ip_group_keys = optional(list(string), [])
        source_ip_group_ids  = optional(list(string), [])

        destination_fqdns     = optional(list(string), [])
        destination_fqdn_tags = optional(list(string), [])
        web_categories        = optional(list(string), [])

        terminate_tls = optional(bool, false)

        protocols = list(object({
          type = string
          port = number
        }))
      }))
    })), {})
  }))

  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}