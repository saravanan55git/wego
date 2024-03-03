# wego

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
