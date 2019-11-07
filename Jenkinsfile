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
            
             sh "docker run -it -v \$(pwd):/dt-infra muhammadhanzala/terraform-test:v2"
         
         }
     }
     
     }

     }
    
       
    