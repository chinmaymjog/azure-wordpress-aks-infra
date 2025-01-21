output "acrname" {
  value = module.hub.container_registry_name
}

output "log_id" {
  value = module.hub.log_analytics_workspace_id
}

output "vwan_id" {
  value = module.hub.vwan_id
}

output "tm_rgname" {
  value = module.hub.tm_rgname
}

output "tm_prod_id" {
  value = module.hub.tm_prod_id
}

output "tm_preprod_id" {
  value = module.hub.tm_preprod_id
}

output "tm_dev_id" {
  value = module.hub.tm_dev_id
}

output "tm_lab_id" {
  value = module.hub.tm_lab_id
}

output "key_vault_id" {
  value = module.hub.key_vault_id
}

output "rsv_vault_name" {
  value = module.hub.recovery_services_vault_name
}

output "bkp_policy_id" {
  value = module.hub.backup_policy_id
}

output "vm_ips" {
  #value = flatten(module.vm.*)
  value = flatten([for i, j in module.vm : j.public_ip])
}

output "runner_ips" {
  #value = module.runners.*
  value = flatten([for i, j in module.runners : j.runner_ips])
}

output "db_rg_name" {
  value = flatten([for i, j in module.database : j.db_rg_name])
}

# output "zname" {
#   value = <<CUSTOM_OUTPUT
#   Hello
#   How are you?
# CUSTOM_OUTPUT
# }