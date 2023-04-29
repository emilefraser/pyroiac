#!/bin/bash

echo "Applying infrastructure..."
terraform apply ${1} --auto-approve
