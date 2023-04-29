::# Ensure you are logged with correct user to the proper subscription
az ad signed-in-user show --query "[displayName,userPrincipalName,userType,accountEnabled,objectId]" --output table
az account show --query id -o tsv 

::# Create sp with scope of the RG as contributor
az ad sp create-for-rbac --name az-sp-tng-tf-dev-san-01 --role="Contributor" --scopes="/subscriptions/83fd1a18-acc9-4081-a0af-9e8d1b1434f5/resourcegroups/az-rg-tng-dev-san-01" 

::The underlying Active Directory Graph API will be replaced by Microsoft Graph API in Azure CLI 2.37.0. Please carefully review all breaking changes introduced during this migration: https://docs.microsoft.com/cli/azure/microsoft-graph-migration
::Creating 'Contributor' role assignment under scope '/subscriptions/83fd1a18-acc9-4081-a0af-9e8d1b1434f5/resourcegroups/az-rg-tng-dev-san-01'
::The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
::{
::  "appId": "d2c4ac33-97d4-439b-a8ef-302e62fa6b84",
::  "displayName": "az-sp-tng-tf-dev-san-01",
::  "password": "HRN-CBik~h7p0JriMTYBYnLXaerOKI-RR4",
::  "tenant": "1e120a60-f9eb-4052-a304-9c9e20d7fcd8"
::}

::# Assign SP rights to the KV
az role assignment create --role "Key Vault Reader" --assignee emile@tangentsolutions.co.za --scope "/subscriptions/83fd1a18-acc9-4081-a0af-9e8d1b1434f5/resourcegroups/az-rg-tng-dev-san-01/providers/Microsoft.KeyVault/vaults/az-kv-tng-tf-dev-san-01" 
::{
::  "canDelegate": null,
::  "condition": null,
::  "conditionVersion": null,
::  "description": null,
::  "id": "/subscriptions/83fd1a18-acc9-4081-a0af-9e8d1b1434f5/resourcegroups/az-rg-tng-dev-san-01/providers/Microsoft.KeyVault/vaults/az-kv-tng-tf-dev-san-01/providers/Microsoft.Authorization/roleAssignments/1ae312ca-c89b-4b8a-b027-3eb210b49198",
::  "name": "1ae312ca-c89b-4b8a-b027-3eb210b49198",
::  "principalId": "ff3887bd-c211-4472-953e-baf1fa157206",
::  "principalType": "User",
::  "resourceGroup": "az-rg-tng-dev-san-01",
::  "roleDefinitionId": "/subscriptions/83fd1a18-acc9-4081-a0af-9e8d1b1434f5/providers/Microsoft.Authorization/roleDefinitions/21090545-7ca7-4776-b22c-e363652d74d2",
::  "scope": "/subscriptions/83fd1a18-acc9-4081-a0af-9e8d1b1434f5/resourcegroups/az-rg-tng-dev-san-01/providers/Microsoft.KeyVault/vaults/az-kv-tng-tf-dev-san-01",
::  "type": "Microsoft.Authorization/roleAssignments"
::}