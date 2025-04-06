#!/bin/bash
# It's really important to know what you are executing. You should find the magic word.
# Hint: The magic word is at the end of this script

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'


echo -e "${YELLOW} Type the magic word to begin...${NC}"
read -p "‍🧙️ Magic word: " typed

echo ""
if [[ "$typed" != "thanks" ]]; then
  echo -e "${RED}❌ Incorrect magic word. Please read the script to find it ${NC}"
  exit 1
fi

# ─────────────────────────────────────────────────────
# Check requirements
# ─────────────────────────────────────────────────────

echo -e "${GREEN}🔍 Checking for Terraform...${NC}"
command -v terraform >/dev/null || { echo -e "${RED}Terraform is not installed.${NC}"; exit 1; }

echo -e "${GREEN}🔍 Checking for AWS CLI...${NC}"
command -v aws >/dev/null || { echo -e "${RED}AWS CLI is not installed.${NC}"; exit 1; }

echo -e "${GREEN}🔍 Checking AWS CLI credentials...${NC}"
aws sts get-caller-identity >/dev/null || { echo -e "${RED}AWS CLI is not authenticated.${NC}"; exit 1; }

# ─────────────────────────────────────────────────────
# Handle S3 Bucket from backend.tf
# ─────────────────────────────────────────────────────

echo -e "${GREEN}🗃️ Checking backend.tf S3 bucket...${NC}"
BUCKET=$(grep "bucket\\s*=\\s*" backend.tf | sed -E "s/.*\"([^\"]+)\".*/\\1/")
echo -e "${YELLOW}Current bucket: $BUCKET${NC}"
read -p "✏️  Do you want to change the bucket name? (yes/no): " CHANGE_BUCKET

if [[ "$CHANGE_BUCKET" == "yes" ]]; then
    read -p "➡️  Enter new bucket name: " NEW_BUCKET
    if [[ -n "$NEW_BUCKET" ]]; then
        echo -e "${GREEN}🔧 Updating backend.tf...${NC}"
        sed -i.bak -E "s/(bucket\\s*=\\s*\")[^\"]+(\".*)/\\1$NEW_BUCKET\\2/" backend.tf
        BUCKET="$NEW_BUCKET"
        echo -e "${GREEN}✅ Bucket updated to: $BUCKET${NC}"
    else
        echo -e "${RED}⚠️  No input given. Keeping original bucket.${NC}"
    fi
fi

echo -e "${GREEN}🔍 Checking access to S3 bucket: $BUCKET...${NC}"
if ! aws s3 ls "s3://$BUCKET" &> /dev/null; then
    echo -e "${RED}❌ Cannot access bucket: $BUCKET${NC}"
    exit 1
fi


# ─────────────────────────────────────────────────────
# Parse variables.tf and prompt for changes
# ─────────────────────────────────────────────────────

echo -e "${GREEN}📄 Reading current variables from variables.tf...${NC}"
echo -e "${YELLOW}---------------------------------------------${NC}"

VAR_DISPLAY=""

while IFS= read -r line; do
  if [[ $line =~ variable[[:space:]]+\"([a-zA-Z0-9_]+)\" ]]; then
    VAR_NAME="${BASH_REMATCH[1]}"
    VAR_DISPLAY+="\n$VAR_NAME"
    continue
  fi

  if [[ $line =~ default[[:space:]]*=[[:space:]]*(.*) ]]; then
    RAW_DEFAULT="${BASH_REMATCH[1]}"
    DEFAULT=$(echo "$RAW_DEFAULT" | sed -E 's/^"//; s/"$//; s/^[[:space:]]+|[[:space:]]+$//g')
    VAR_DISPLAY+=" = $DEFAULT"
  fi
done < variables.tf

# Show the full list
echo -e "$VAR_DISPLAY"
echo -e "${YELLOW}---------------------------------------------${NC}"

# Ask if user wants to continue
read -p "✅ Are these values OK to proceed with? (yes/no): " confirm_vars
if [[ "$confirm_vars" != "yes" ]]; then
  echo -e "${RED}❗ Please edit variables.tf manually and re-run the script.${NC}"
  exit 1
fi

# ─────────────────────────────────────────────────────
# Terraform execution
# ─────────────────────────────────────────────────────

echo -e "${GREEN}📦 Running terraform init...${NC}"
terraform init

echo -e "${GREEN}🧠 Running terraform plan...${NC}"
terraform plan -out=tfplan

read -p "📝 Do you want to proceed with terraform apply? (yes/no): " confirm_apply
if [[ "$confirm_apply" != "yes" ]]; then
    echo -e "${RED}🚫 Aborted by user.${NC}"
    exit 0
fi

echo -e "${GREEN}🚀 Applying Terraform...${NC}"
terraform apply tfplan

# ─────────────────────────────────────────────────────
# Post-deploy: Test ALB
# ─────────────────────────────────────────────────────

echo -e "Sleeping a bit"
sleep 10

echo -e "${GREEN}🌐 Extracting Load Balancer DNS...${NC}"
LB_DNS=$(terraform output -raw load_balancer_dns)

if [[ -z "$LB_DNS" ]]; then
    echo -e "${RED}❌ Load balancer DNS not found.${NC}"
    exit 1
fi

echo -e "${GREEN}📡 Curling the deployed endpoint...${NC}"
curl -i "http://$LB_DNS"

#MAGIC WORD: thanks
