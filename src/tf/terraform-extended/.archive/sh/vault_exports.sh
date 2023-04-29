export VAULT_ADDR=
export VAULT_NAMESPACE=admin
export VAULT_FORMAT=json
export VAULT_TOKEN=
export VAULT_APPROLE=terraform

# Enable approle
vault auth enable approle

# create new role
vault write auth/approle/role/${VAULT_APPROLE} \
      secret_id_num_uses=1000 \
      secret_id_ttl=4h \
      token_num_uses=20 \
      token_ttl=4h \
      token_max_ttl=5h \
      token_type=default \
      period="" \
      policies="default","terraform","keyvault"


# read role-id
export VAULT_ROLEID=$(vault read auth/approle/role/${VAULT_APPROLE}/role-id | jq -r '.data.role_id')

# write secret id
export VAULT_SECRETID=$(vault write -f auth/approle/role/${VAULT_APPROLE}/secret-id | jq -r '.data.secret_id')



# write to get token 
export VAULT_TOKEN=$(vault write auth/approle/login role_id="${VAULT_ROLEID}" secret_id="${VAULT_SECRETID}" | jq -r '.auth.client_token')


vault write auth/approle/role/${VAULT_APPROLE}/policies policies="default,terraform,keyvault"

hvs.CAESIG9ezASi2Ju658TLAi_06QNl6oPtduHeBiIpFEOH-9niGicKImh2cy43NExZeGVMOXI2c3ZyUWFwSEFpQVBTSjguZFh5UGgQlmA