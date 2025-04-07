## Assignment

This project uses **Terraform** to deploy Docker image : `nmatsui/hello-world-api` to AWS.

## ⚠️ Please verify the ***variables.tf*** and ***backend.tf*** files before execution! ⚠️

---

## ⚙️ Requirements

- Terraform `>= 1.3`
- AWS CLI authenticated (with permissions to create ECS, ALB, IAM, S3, etc.)

---

## 📐 Application Architecture Overview

- **VPC** with public subnets in 2 availability zones
- **ALB (Application Load Balancer)**: public-facing on port `80`
- **ECS Service**: runs the container with `desired_count` replicas
- **ALB Target Group Health Checks** to container's port `3000`
- **Least-privilege Security Groups**:
    - ALB: allows `0.0.0.0/0` on port `80`
    - ECS: only allows traffic from ALB on container port

---

## 🛠️ Terraform Architecture Overview

- Uses **S3 backend** for remote state storage and collaboration
- Using modules so that we can achieve **reusability** (networking, ALB, ECS)
- Separation of different application architecture logic for easy editing

### 📁 Folder Structure

```hcl
├── main.tf               # Root module, wires all submodules
├── variables.tf          # Global variables (image, port, replicas, etc.)
├── backend.tf            # Terraform S3 backend configuration
├── provider.tf           # AWS provider setup
├── output.tf             # Root-level outputs (e.g., ALB DNS for easy curl test)

├── networking/           # VPC, public subnets, IGW, route table, security groups
│   ├── vpc.tf
│   ├── subnets.tf
│   ├── gateway.tf
│   ├── security_groups.tf
│   ├── variables.tf
│   └── outputs.tf

├── alb/                  # Application Load Balancer module
│   ├── lb.tf             # ALB resource definition
│   ├── listener.tf       # ALB listener with forwarding rule
│   ├── target_group.tf   # Target group (health checks)
│   ├── variables.tf
│   └── outputs.tf

└── ecs/                  # ECS Fargate cluster, task, and service
├── cluster.tf
├── task.tf           # Task definition (image, port mappings)
├── service.tf        # ECS service
├── iam.tf            # Execution IAM role and policy
├── variables.tf
└── outputs.tf
```
Each module accepts input variables from the variables.tf from the root directory.

---

## 🛠️ AWS Setup Prerequisites

Before running `terraform init`, ensure the following:

### ✅ AWS CLI is configured

Run:

```bash
aws configure
```

Make sure you have valid AWS credentials and a default region set. You can test AWS access with : 

```bash
aws sts get-caller-identity
```

---

### ✅ S3 Backend Bucket Exists

Terraform stores its remote state in an S3 bucket (see `backend.tf`).  
Make sure the bucket defined there **already exists**, and is located in the correct region.

You can check and create the bucket with:

```bash
aws s3api create-bucket \
  --bucket your-bucket-name \
  --region your-region \
  --create-bucket-configuration LocationConstraint=your-region
```

> ⚠️ **Special case**: If your region is `us-east-1`, do **not** pass the `--create-bucket-configuration` flag:
```bash
aws s3api create-bucket \
  --bucket your-bucket-name \
  --region us-east-1
```

> ℹ️ The region and bucket name must match what’s defined in `backend.tf`.


---

## 🚀 How to Deploy

1. **Initialize Terraform**

    ```bash
    terraform init
    ```

2. **Review the plan**

    ```bash
    terraform plan
    ```

3. **Apply**

    ```bash
    terraform apply
    ```

4. **Get the ALB DNS**

   After apply, Terraform will output something like:

    ```
    load_balancer_dns = <lb-dns>
    ```

   To test the success of the assignment you should use the following command:
    ```bash
    curl http://<lb-dns>
    ```
   The response should look something like this : 
   ```
    HTTP/1.1 200 OK
    Date: Sun, 06 Apr 2025 19:54:19 GMT
    Content-Type: application/json
    Transfer-Encoding: chunked
    Connection: keep-alive
    
    {"message":"hello world!"}%
   ```
   You can also test port 3000 to see that it will return **"Connection timeout"** error
   ```bash
   curl http://<lb-dns>:3000
   ```

---

## ⚙️ Customization

You can change key parameters using Terraform variables:

| Variable               | Default                        | Description                             |
|------------------------|--------------------------------|-----------------------------------------|
| `aws_region`           | `eu-central-1`                 | AWS region to deploy into               |
| `app_name`             | `m2m-docker-aws-hello-world`   | Naming prefix for AWS resources         |
| `image`                | `nmatsui/hello-world-api`      | Docker image to run in ECS              |
| `container_port`       | `3000`                         | Port exposed by the container           |
| `replicas`             | `1`                            | Number of ECS tasks to run              |
| `allowed_ingress_cidr` | `0.0.0.0/0`                    | Who can access the ALB (default: open)  |

You can override these by editing `variables.tf` file in the root directory. Or by using the CLI like so :

```bash
terraform apply -var="replicas=2" -var
```

## 🧹 How to Destroy

To tear down everything created by Terraform:
```
terraform destroy
```
To destroy without confirmation prompt:
```
terraform destroy -auto-approve
```

## 📓 Notes
- This deploys only the application and its network infra — no HTTPS and no domain.
- IAM roles, security groups, and network resources are tagged for traceability in AWS.
- Terraform should deploy 19 resources on a fresh instance.
