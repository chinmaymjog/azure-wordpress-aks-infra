location       = "westeurope"
location_short = "weu"
aks_env        = "lab"

#Logstash vars
enable_logstash = "false"
vmsize          = "Standard_B4ms"
osdisksize      = "64"

#Redis Vars
enable_redis      = "false"
redis_capacity_gb = "3"
redis_family      = "P"
redis_sku         = "Premium"

#AKS Vars
node_vmsize      = "Standard_D4ads_v5"
agent_count      = "6"
os_disk_size_gb  = "64"
os_disk_type     = "Ephemeral"
aks_vnet         = ["10.44.0.0/20"]
nodepool_subnet  = ["10.44.0.0/21"]
dns_service_ip   = "10.44.8.10"
service_cidr     = "10.44.8.0/22"
resources_subnet = ["10.44.12.0/27"]

authorized_ip_range = ["198.51.100.3", "198.51.100.4", "198.51.100.2"]

