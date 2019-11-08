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
     stage('Generating kubeconfig'){
           steps{
          
            sh "cd examples/gke-private-cluster && gcloud auth activate-service-account --key-file gcloud-sa.json"
            sh "gcloud beta container clusters get-credentials example-private-cluster --region europe-west3 --project stunning-crane-234500"

         }
     }
     stage('Deploying helm chart'){
           steps{
          
            
             sh "helm install ingress stable/nginx-ingress  --namespace mypod"

         }
     }

     }

     }
    
       
    