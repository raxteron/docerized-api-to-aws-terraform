# Deployment: Hello World API with Terraform

This project provisions a simple containerized **Hello World API** (`nmatsui/hello-world-api`) to AWS using **Terraform** and **ECS Fargate**, fronted by a public **Application Load Balancer (ALB)**.

It includes both a manual, modular setup and an automated script-driven flow.

---

## 🧭 Project Structure

```
├── manual-work/     # Modular Terraform setup (VPC, ALB, ECS)
├── script-work/     # Automation script that wraps the same infrastructure
├── timetrace.report # Summary of tracked time spent on the assignment
└── README.md        # You are here
```
---

## 🕒 Time Tracking

This project was time-tracked using [\`timetrace\`](https://github.com/dominikbraun/timetrace).  
You can view the full log in the file:  
📄 \`timetrace.report\`


---

## 🧱 Infrastructure Overview

- **AWS ECS ** to run the docker image
- **Application Load Balancer (ALB)** to expose the service on port \`80\`
- **VPC** with public subnets and security groups
- **Terraform** modules split into logical components
- **S3** backend for tfstate file 
---

## 📂 Manual Setup (\`manual-work/\`)

The \`manual-work/\` folder contains:

- Modular Terraform code, structured by:
    - \`networking/\`: VPC, subnets, routing, SGs
    - \`alb/\`: Application Load Balancer and target group
    - \`ecs/\`: ECS cluster, service, task definition, IAM
- \`terraform.tfvars\` and variables are edited manually
- Suitable for direct use with \`terraform plan\` / \`apply\`

---

## ⚙️ Scripted Deployment (\`script-work/\`)

The \`script-work/\` folder provides an interactive experience via:

### 🧪 \`deploy_and_test.sh\`

A Bash script that:

- Checks for Terraform and AWS CLI availability
- Validates AWS credentials and S3 backend access
- Displays current variables from \`variables.tf\`
- Asks for user confirmation before continuing
- Runs Terraform end-to-end (\`init\`, \`plan\`, \`apply\`)
- Tests the resulting load balancer via \`curl\`
- Includes a "magic word" prompt as a fun security step 🧙

---


## 🚀 How to Deploy

Choose your preferred approach:

### Option A: Manual

#### Please be sure to check your variables.tf file before executing

```bash
cd manual-work
terraform init
terraform plan
terraform apply
```

### Option B: Automated

I've included the script as a little fun experiment as I had time on the clock. It's not dangerous, but it's always good to know what you will execute, so if you have the time double check it.

```bash
cd script-work
chmod +x deploy_and_test.sh
./deploy_and_test.sh
```

---

## 🧼 How to Destroy

This applies to both manual and script approaches.

```bash
terraform destroy
```
