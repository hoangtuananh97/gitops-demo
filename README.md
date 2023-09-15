# gitops-demo

pip install -r terraform/modules/lambda/requirments_lambda.txt -t terraform/modules/lambda/venv/lib/python3.10/site-packages

terraform init

terraform plan -out plan.out
terraform plan -out plan.out -var-file="config.tfvars"

terraform show -json plan.out > plan.json

terraform apply "plan.out"
terraform apply -var-file="config.tfvars"

terraform destroy
terraform destroy -var-file="config.tfvars"
