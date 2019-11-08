pipeline{
       
    agent any 
    stages{       
       
    stage('checkout source code'){
           steps{
            
            checkout scm
             sh "ls"
         }
     }
     stage('terraform build'){
           steps{
            
            //  sh "docker run -v \$(pwd):/dt-infra muhammadhanzala/terraform-test:v2 bash -c 'cd /dt-infra/examples/gke-private-cluster && terraform init && terraform apply --auto-approve'"
             sh "docker run -v \$(pwd):/dt-infra muhammadhanzala/terraform-test:v3 bash -c 'cd /dt-infra/examples/gke-private-cluster/ && terraform init && terraform apply --auto-approve'"
         }
     }
     
     }

     }
    
       
    