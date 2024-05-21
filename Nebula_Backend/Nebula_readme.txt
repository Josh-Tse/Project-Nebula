Requirements for this project 

1. vscode
2. aws cli
3. docker desktop
4. python

Creating the lambda functions and building docker image

1. define your lambda functions in folder "Lambda Functions"
	ex. lambda_function1.py etc

2. add a requirement.txt file with your python code dependencies inside eg. boto3

3. write a dockerfile with the following details

FROM public.ecr.aws/lambda/python:3.11

COPY . .

RUN pip install -r requirements.txt

4. after defining all your lambda functions run the following commands to push to ecr

"docker build --platform linux/amd64 -t nebula_lambda_functions:v1 ."


"aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <your aws account ID>.dkr.ecr.us-east-1.amazonaws.com"

"aws ecr create-repository --repository-name <your ecr repository name> --image-scanning-configuration scanOnPush=true --image-tag-mutability MUTABLE"

"docker tag nebula_lambda_functions:v1 <your aws account ID>.dkr.ecr.us-east-1.amazonaws.com/<your ecr repository name>:Version_1.0"

"docker push <your aws account ID>.dkr.ecr.us-east-1.amazonaws.com/<your ecr repository name>:Version_1.0"


5. Retreive your ecr image url by running these commands

"aws ecr describe-repositories --repository-name <your ecr repository name>"

copy the repository uri from the output

append your ecr image tag to the repository uri ex. <repo uri>:<tag>


note this complete image uri for use in creating our api gateway in terraform code later


6. terraform code for api gateway

create a variables.tf file




