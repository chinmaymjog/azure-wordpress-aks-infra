location            = "northeurope"
location_short      = "neu"
env                 = "lab"
node_vmsize         = "Standard_D4ads_v5"
agent_count         = "2"
os_disk_size_gb     = "64"
os_disk_type        = "Ephemeral"
vnet                = ["10.45.0.0/20"]
nodepool_subnet     = ["10.45.0.0/21"]
dns_service_ip      = "10.45.8.10"
service_cidr        = "10.45.8.0/22"
resources_subnet    = ["10.45.12.0/27"]
authorized_ip_range = ["203.0.113.10"]

