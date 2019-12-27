variable "project" {
  description = "The project ID where all resources will be launched."
  type        = "string"
  default = "helical-button-259312"
}

variable "location" {
  description = "The location (region or zone) of the GKE cluster."
  type        = "string"
  default = "europe-west3"
}

variable "region" {
  description = "The region for the network. If the cluster is regional, this must be the same region. Otherwise, it should be the region of the zone."
  type        = "string"
  default = "europe-west3"
}
variable "vpc_cidr_block" {
  description = "The IP address range of the VPC in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = "string"
  default     = "10.3.0.0/16"
}

# For the example, we recommend a /16 network for the secondary range. Note that when changing the size of the network,
# you will have to adjust the 'cidr_subnetwork_width_delta' in the 'vpc_network' -module accordingly.
variable "vpc_secondary_cidr_block" {
  description = "The IP address range of the VPC's secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = "string"
  default     = "10.4.0.0/16"
}
variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = "string"
  default     = "example-private-cluster"
}