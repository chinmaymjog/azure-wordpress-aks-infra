# IP block for virtual network

vwan_ip_block = "10.50.1.0/24"

vnet_ip_block = ["10.50.0.0/24"]

endpoint_subnet_prefixes = ["10.50.0.0/26"]
vm_subnet_prefixes       = ["10.50.0.64/26"]
runner_subnet_prefixes   = ["10.50.0.128/26"]


# VM size to create bastion, rancher, sonarqube & runners VMs
vmsize = "Standard_B4ms"

# Disk Size
osdisksize   = "64"
datadisksize = "64"

# Map of VMs to create. Toggle 'vm_enabled' ture or false to create VM
vm = {
  bastion = {
    vm_enabled = "true",
    name       = "bastion",
  },
  rancher = {
    vm_enabled = "false",
    name       = "rancher",
  },
  sonarqube = {
    vm_enabled = "false",
    name       = "sonarqube",
  }
}

# Map of gitlab runners to create. Toggle 'runner_enabled' ture or false to gitlab runners for desired environment 
runners = {
  dev = {
    runner_enabled = "true",
    env            = "dev",
    instance_count = "2",
  },
  preprod = {
    runner_enabled = "false",
    env            = "preprod",
    instance_count = "2",
  },
  prod = {
    runner_enabled = "true",
    env            = "prod",
    instance_count = "2",
  }
}

# Map of database to create. Toggle 'db_enabled' ture or false to create database for desired environment.
# Note : You MUST set 'dbsku','dbsize','dbadminuser' carfully. Changing it after resource creation will force it to recreate.
# You can list 'dbsku' by 'az mariadb server list-skus --location <LOCATION> -o table'

db_subnet_prefixes = ["10.50.0.224/27"]
database = {
  dev = {
    db_enabled  = "true"
    env         = "dev"
    dbsku       = "GP_Standard_D4ds_v4"
    dbsize      = "64"
    dbversion   = "8.0.21"
    dbadminuser = "dev_admin"
  },
  preprod = {
    db_enabled  = "true"
    env         = "preprod"
    dbsku       = "GP_Standard_D4ds_v4"
    dbsize      = "64"
    dbversion   = "8.0.21"
    dbadminuser = "preprod_admin"
  },
  prod = {
    db_enabled  = "true"
    env         = "prod"
    dbsku       = "GP_Standard_D4ds_v4"
    dbsize      = "64"
    dbversion   = "8.0.21"
    dbadminuser = "prod_admin"
  }
}

authorized_ip_range = ["198.51.100.3", "198.51.100.4", "198.51.100.2"]
