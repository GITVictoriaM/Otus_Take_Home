# Welcome Otus Team!
![This is an image](https://gitpublicimages.s3.us-east-2.amazonaws.com/main-otus-logo-small.png)

## Dependencies

In order to run the following configuration you will need to have the following installed to their latest versions:

Kubectl from Kubernetes [Link](https://kubernetes.io/docs/tasks/tools/) </br>
Terraform [Link](https://learn.hashicorp.com/tutorials/terraform/install-cli) </br>
AWS IAM Authenticator [Link](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)</br>
wget [Link](https://www.jcchouinard.com/wget/)


## Initialize

1. With the repo downloaded `cd` into the directory
2. In a Terminal/Command Line with administrator access run `terraform init`
3. Ensure you have configured aws by running `aws configure` and setting it to your desired region *(terraform may fail if the region in your aws config does not match the attribute in _tfvars.tf file*
4. Open the _tfvars.tf file and fill in the following fields [ **region** (with desired region),**admin_acct_arn** (with the ARN of the user being used to execute the terraform), **admin_acct_username** (with the username of the user being used to execute the terraform {ex. EKS_Admin}) ]
5. Run `terraform apply` followed by yes in the resulting prompt
6. `terraform apply` may have to be run more than once depending on the speed of deployment of the cluster *(This is AWS dependent)*
7. Once completed you may copy the configuration file from the output manually or run the following command `aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)`
8. Allow for 2-3 minutes for the ingress application load balancer to be established.


## Requirements

The following is from the Take Home Assignment document
### Descirption
Automate thru code the creation of a Kubernetes cluster on AWS using EKS and deploy of
a simple app to it

### Assignment
Publish a repo on github that we can clone and run to setup a fully functioning EKSbased
K8s cluster on AWS using Terraform

1. Deployment should support autoscaling (HPA)
2. Ingress Controller (Nginx)
3. 1 node group
4. Any app to test with

## Verification

- To verify the assignment has autoscaling via hpa enabled run `kubectl get hpa`
- To verify the nodegroup check the AWS EKS cluster console and look under nodes.
- To verify the ingress controller run `kubectl get ingress`
- To verify the application is successfully running take the URL from the `kubectl get ingress` and go to it using a browser
