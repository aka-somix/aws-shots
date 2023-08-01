# AWS SHOT 1 - How to Pass Parameters From Eventbridge to AWS Batch


## 🚨 DISCLAIMER 🚨
Despite AWS Batch and Eventbridge only charges per use, other services needed for this demo may have different
billing strategies (like ECR that is billed per storage used).

Before using this solution, make sure that you have understood the resources that will be deployed and used, as well as their costs. Thank you.

## Deploy this solution

### Prerequisites
- [Terraform]()
- [AWS CLI]()
- [Podman]() (or Docker, but you will need to update the [null_resource here]() and replace podman with docker)
- An AWS Account with a VPC

### Before Deploying
Create a .env file with the following variables:
```
TF_VAR_owner= <Your Name>
TF_VAR_vpc_name= <Your VPC Name>
TF_VAR_demo_subnet_name= <The subnet name where you want to deploy this solution>
TF_VAR_aws_region= <The AWS Region where you want to deploy this solution>
```
Alternatively you can export this variables by yourself each time.

### Deploy with Terraform
First, open a terminal and make sure to have your AWS Credential ready.
To test it, you can run:
```bash
aws sts get-caller-identity
```
And assert that you are using the correct credentials 

Change directory to go inside the AWS-SHOT#1 root folder:
```bash
cd "01-PassParametersFromEventbridgeToBatch"
```

To export all the variables as env variables in a unix-like shell, run:
```bash
set -a && source .env && set +a  
```

Then you can use Terraform to deploy your solution:
```bash
terraform init
```
```bash
terraform apply
```

### Test the Solution by sending a test event
For testing this solution, of course, you will need to have IAM permissions to perform the `events:PutEvent` action on the default Event Bus in your AWS Account.
Provided that your currently exported AWS Profile have this permission, then you can use the `test-event.json` file to send an example event.

To do so, first change directory to the AWS-SHOT#1 root folder:
```bash
cd "01-PassParametersFromEventbridgeToBatch"
```

Then run this command:
```bash
aws events put-events --entries file://test-event.json
```

Once it returns Ok, you should see on the AWS Batch Dashboard that a Job has been scheduled. You can inspect the
solution to see how it works.


### Dismiss the Solution
Once you are done inspecting the solution, you can dismiss all the resources created by running:
```bash
terraform destroy
```
