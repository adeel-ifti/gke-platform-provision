variable "client_key"{
description= "client key for server authentication"

}
variable "client_certificate"{
description= "client certificate for server authentication"

}
variable "client_ca_certificate"{
description= "client  ca certificate for server authentication"

}
variable "endpoint"{
    description = "cluster endpoint for authenticaiton"
}
variable "dependednt_variable"{
   description = "using it as hack to create/delete node pool before helm"

}
variable "helm_version"{
   description = "tiller version to be used"
   default = "v2.13.0"
}
variable "service_account_name"{
  description = "Tiller service account name"
  default = "tiller"

}