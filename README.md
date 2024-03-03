# wego

Aws console access :  

Account id: 851725301149

IAM user : demo-user

IAM Pass : Password@123

you can access the fortune api application via below Api endpoint url :

                                                  http://52.91.91.19:8080/

                                                  http://52.91.91.19:8080/healthcheck

                                                  http://52.91.91.19:8080/v1/fortune
**Docker image Build**

step 1: Cloned the code https://github.com/wego/devops-fortune-api/tree/main/api  to my local

step 2 : installed docker on my system

step 3: Following the below commands built a new docker image 

     cd api

     docker build -t fortune-api .

     docker run -d -p 8080:8080  --name fortune-container fortune-api

**Pushing the image to ECR**

step 1 : Created new repository in ECR Aws Console

step 2 : By using below commands pushed the image the ECR repo

     aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 851725301149.dkr.ecr.us-east-1.amazonaws.com

     docker tag fortune:latest 851725301149.dkr.ecr.us-east-1.amazonaws.com/fortune:latest

     docker push 851725301149.dkr.ecr.us-east-1.amazonaws.com/fortune:latest

**ECS Cluster creation in AWS using terraform**

step 1 : Created a new IAM user and assigned IAM permissions

step 2 : using terraform code created a ECS cluster with EC2 resource

Terraform created the following resources

       ECS Cluster

       Ec2  

       Security Group ---> Allow the 8080 port in the inbound rules 

       Vpc ,Subnet

       IAM policies 

       ECS task definition ..etc

step 3 : Once resource are created in the EC2 infrastructure have installed docker and deployed the docker image using the following commands 

    sudo yum update -y
  
    sudo yum install docker
    
    sudo service docker start
    
    sudo usermod -a -G docker ec2-user
    
    docker ps
    
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 851725301149.dkr.ecr.us-east-1.amazonaws.com
     
    docker pull 851725301149.dkr.ecr.us-east-1.amazonaws.com/fortune:latest  ----->   Pulling the docker image from ECR to the server
     
    docker images  ----> list the docker images in the system
    
    docker run -d -p 8080:8080  --name fortune-container 851725301149.dkr.ecr.us-east-1.amazonaws.com/fortune  -----> running the docker image as container in port 8080 in detached mode
    
    docker ps -a   ------> It will show the running container in the system
