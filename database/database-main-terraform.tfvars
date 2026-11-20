location                 = "eastus2"
location_short           = "eus2"
env                      = "main"
dbsku                    = "B_Standard_B1ms"
dbsize                   = "20"
dbversion                = "8.0.21"
storage_account_tier     = "Standard"
storage_replication_type = "LRS"

# Storage firewall: the WordPress storage account denies public access by default.
authorized_ip_range = ["203.0.113.10"] # your public IP, for scripts/uploads
# After the AKS cluster exists, add its node subnet ID so pods can mount the file share:
# storage_subnet_ids = ["/subscriptions/<id>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<aks-subnet>"]
