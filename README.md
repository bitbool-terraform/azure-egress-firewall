### Changelog

| Version    | Changes |
| -------- | ------- |
| v1.0.1  | Minor bugs fixed.   |
| v1.0.0  | First stable, synced with all projects.   |


```terraform
rule_collection_groups = {
    "application_collection_group_sample" = {
      priority = 
      # network_rule_collections = {}
      application_rule_collections = {
        "collection1" = {
          priority = 
          action   = "Allow"
          rules = {
            "rule1" = {
              destination_fqdns = [""]
              source_addresses  = ["*"]
              protocols = [{type = "Http", port = 80},{type = "Https",port = 443}]
            }
          }
        }
      }
    }
    "network_collection_group_sample" = {
      priority = 
      # application_rule_collections = {}
      network_rule_collections = {
        "collection1" = {
          priority =
          action   = "Allow"
          rules = {
            "rule1" = {
              protocols             = ["Any"]
              destination_addresses = ["*"]
              destination_ports = ["*"]
              source_addresses = []
            }
          }

        }
      }
    }
}
```