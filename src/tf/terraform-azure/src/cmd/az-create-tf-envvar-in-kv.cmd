:: Ensure the person running this has adequate rights
:: Need to have at least secret officer or Keyvault Administrator rights
az keyvault secret set --name ARM-TENANT-ID --vault-name az-kv-tng-tf-dev-san-01 --value 1e120a60-f9eb-4052-a304-9c9e20d7fcd8
az keyvault secret set --name ARM-SUBSCRIPTION-ID --vault-name az-kv-tng-tf-dev-san-01 --value 83fd1a18-acc9-4081-a0af-9e8d1b1434f5
az keyvault secret set --name ARM-CLIENT-ID --vault-name az-kv-tng-tf-dev-san-01 --value d2c4ac33-97d4-439b-a8ef-302e62fa6b84
az keyvault secret set --name ARM-CLIENT-SECRET --vault-name az-kv-tng-tf-dev-san-01 --value HRN-CBik~h7p0JriMTYBYnLXaerOKI-RR4
