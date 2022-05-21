init:
	terraform init

validate:
	terraform validate -var-file="secrets.tfvars"

plan:
	terraform plan -var-file="secrets.tfvars"

apply:
	terraform apply -var-file="secrets.tfvars"

destroy:
	terraform destroy -var-file="secrets.tfvars"