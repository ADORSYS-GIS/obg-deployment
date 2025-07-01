#!/bin/bash

# Project root
mkdir -p terraform/{modules,scripts}

# Top-level files
touch terraform/{main.tf,provider.tf,variables.tf,outputs.tf}

# Modules
for mod in vpc ec2 acm dns cloudwatch; do
  mkdir -p terraform/modules/$mod
  touch terraform/modules/$mod/{main.tf,variables.tf,outputs.tf}
done

# Scripts
touch terraform/scripts/bootstrap.sh

echo "✅ Terraform project structure with CloudWatch module created!"

