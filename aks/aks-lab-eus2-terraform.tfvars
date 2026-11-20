location            = "eastus2"
location_short      = "eus2"
env                 = "lab"
node_vmsize         = "Standard_B2ms"
agent_count         = "1"
os_disk_size_gb     = "64"
os_disk_type        = "Managed"
vnet                = ["10.44.0.0/20"]
nodepool_subnet     = ["10.44.0.0/21"]
dns_service_ip      = "10.44.8.10"
service_cidr        = "10.44.8.0/22"
resources_subnet    = ["10.44.12.0/27"]
authorized_ip_range = ["203.0.113.10"]

