pipeline{
       
    agent any 
    stages{       
       
    stage('checkout source code'){
           steps{
            
            checkout scm
             sh "ls"
         }
     }
     stage('terraform planing'){
           steps{
            sh "cd examples/gke-private-cluster && terraform plan --out tfplan"
            
            
         }
     }
     stage('Approving terraform plan'){
           steps{
          
            sh "cd examples/gke-private-cluster && terraform apply  tfplan"
            
         }
     }

     }

     }
    
       
    