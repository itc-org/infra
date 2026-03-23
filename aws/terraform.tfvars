aws_region = "eu-west-2"

s3_bucket_prefix = "terraform-sandbox"

ecs_container_image = "nginx:latest"

opensearh_instance_type = "t3.small.search"

##SageMaker##
notebook_instance_type = "ml.t3.medium"


##EC2##
vpc_cidr_block    = "10.0.0.0/16"
ec2_ami           = "ami-0ba0c1a358147d1a8"
ec2_instance_type = "t3.micro"
key_name          = "terraform-keypair"


##RDS##
rds_db_username = "admin"
rds_db_password = "Terraform123!"
rds_engine      = "mysql"


##Redshift##
redshift_master_username = "admin"
redshift_master_password = "Terraform123!"


##lambda##
lambda_role_arn = "arn:aws:iam::123456789012:role/lambda-role"
lambda_runtime  = "python3.11"
lambda_handler  = "lambda_function.lambda_handler"


###SQS###
sqs_queue_name                 = "orders"
sqs_delay_seconds              = 0
sqs_max_message_size           = 262144
sqs_message_retention_seconds  = 345600
sqs_visibility_timeout_seconds = 30

##APIGW##
apigw_count = 2