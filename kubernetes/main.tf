terraform {
  # The modules used in this example have been updated with 0.12 syntax, additionally we depend on a bug fixed in
  # version 0.12.7.
  required_version = ">= 0.12.7"
  
  backend "gcs" {

    bucket  = "test-tf-kubernetes"
    
    prefix  = "terraform/state"

   }

}
data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket  = "test-tf-vpc"
    prefix  = "terraform/state"
  }
}

module "gke_cluster" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-cluster?ref=v0.2.0"
  source = "../modules/gke-cluster"
  
  name = "${var.cluster_name}"

  project  = "${var.project}"
  location = "${var.location}"
  network = data.terraform_remote_state.vpc.outputs.network
 
 
  # We're deploying the cluster in the 'public' subnetwork to allow outbound internet access
  # See the network access tier table for full details:
  # https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier
  subnetwork = data.terraform_remote_state.vpc.outputs.public_subnetwork

  # When creating a private cluster, the 'master_ipv4_cidr_block' has to be defined and the size must be /28
  master_ipv4_cidr_block = "${var.master_ipv4_cidr_block}"

  # This setting will make the cluster private
  enable_private_nodes = "true"

  # To make testing easier, we keep the public endpoint available. In production, we highly recommend restricting access to only within the network boundary, requiring your users to use a bastion host or VPN.
  disable_public_endpoint = "false"

  # With a private cluster, it is highly recommended to restrict access to the cluster master
  # However, for testing purposes we will allow all inbound traffic.
  master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = "0.0.0.0/0"
          display_name = "all-for-testing"
        },
      ]
    },
  ]

  cluster_secondary_range_name = data.terraform_remote_state.vpc.outputs.public_subnetwork_secondary_range_name
}
resource "google_container_node_pool" "node_pool" {
  provider = "google-beta"

  name     = "private-pool-1"
  project  = "${var.project}"
  location = "${var.location}"
  cluster  = "${module.gke_cluster.name}"

  initial_node_count = "1"

  autoscaling {
    min_node_count = "1"
    max_node_count = "5"
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }
  # provisioner "local-exec" {
  #   command = "./install.sh"
    
    

  #   environment = {
  #     CLUSTER_NAME = "${module.gke_cluster.name}"
  #     REGION = "${var.region}"
  #     PROJECT_ID = "${var.project}"
  #   }
  #   }
  node_config {
    image_type   = "COS"
    machine_type = "n1-standard-2"

    labels = {
      private-pools-example = "true"
    }

    # Add a private tag to the instances. See the network access tier table for full details:
    # https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier
    tags = [
      "${data.terraform_remote_state.vpc.outputs.private}",
      "private-pool-example",
    ]

    disk_size_gb = "30"
    disk_type    = "pd-standard"
    preemptible  = false

    service_account = "${module.gke_service_account.email}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    
    
  }

  
  #     lifecycle {
  #   ignore_changes = [
  #     tags["node_config"],
  #   ]
  # }
  

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CUSTOM SERVICE ACCOUNT TO USE WITH THE GKE CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

module "gke_service_account" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-service-account?ref=v0.2.0"
  source = "../modules/gke-service-account"

  name        = "${var.cluster_service_account_name}"
  project     = "${var.project}"
  description = "${var.cluster_service_account_description}"
}
module "helm"{
  source = "../modules/helm"
  endpoint = module.gke_cluster.endpoint
  client_key = module.gke_cluster.client_key
  client_certificate = module.gke_cluster.client_certificate
  client_ca_certificate= module.gke_cluster.cluster_ca_certificate
  dependednt_variable = google_container_node_pool.node_pool.name

}

