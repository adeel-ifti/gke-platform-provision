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
            
             sh "docker run -it -v $(WORKSPACE):/dt-infra muhammadhanzala/terraform-test:v2"
         
         }
     }
     
     }

     }
    
       
    