#!/bin/bash

echo "Planning infrastructure..."
terraform plan -out=${1} -input=false -lock=false
