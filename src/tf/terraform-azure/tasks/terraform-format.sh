#!/bin/bash

echo "Formatting terraform code..."
terraform fmt -diff -check -recursive
