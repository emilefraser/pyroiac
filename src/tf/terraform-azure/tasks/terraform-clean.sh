#!/bin/bash

echo "Cleaning terraform artefacts..."
rm -rf .archive
rm -rf .terraform
rm -f tfplan
rm -f terraform.tfstate
rm -f .terraform.lock.hcl
