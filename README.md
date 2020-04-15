# Audit Unauthorized access to S3 Buckets

This is a terraform code to deploy the necessary infrastructure to identify unauthorized activity to a S3 bucket.

![Solution Schema](solution-schema.png)

Deployment details can be found here: https://attackiq.com/blog/2020/04/14/defeating-a-cloud-breach-part-3/

Notifications will be send by email using the SNS service. An email subscription to the SNS topic is needed once the TF is deployed.

## Requirements

- Terraform v0.12.18


## Deploy

- Create a ZIP file to deploy the lambda function:

```
# make all
```

- Initialize Terraform

```
# terraform init
```

- Deploy

```
# terraform apply
```

Variables needed:
* monitored_bucket: Bucket name to monitor
* name: Solution name. This value is used when naming resources.

