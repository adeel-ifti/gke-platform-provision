output "network"{
  description = "VPC network created by terraform script"
  
  value       = module.vpc_network.network

}
output "public_subnetwork"{
  description = "VPC public  sub-network created by terraform script"
  
  value       = module.vpc_network.public_subnetwork

}
output "private"{
  description = "VPC public  sub-network created by terraform script"
  
  value       = module.vpc_network.private

}
output "public_subnetwork_secondary_range_name"{
  description = "VPC public  sub-network created by terraform script"
  
  value       = module.vpc_network.public_subnetwork_secondary_range_name

}