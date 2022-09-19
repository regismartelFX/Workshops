output "primary_region" {
  description = "Azure region where resources should be primarily deployed."
  value = {
    display_name = "Canada Central"
    name         = "canadacentral"
    code         = "cc"
  }
}

output "secondary_region" {
  description = "Azure region where backup / fail over resources should be deployed."
  value = {
    display_name = "Canada East"
    name         = "canadaeast"
    code         = "ce"
  }
}
