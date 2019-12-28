#!/bin/bash
if [[ $1 == "all" ]] ; then 
  declare -a TF_LAYER=( "vpc" "kubernetes")
else
  TF_LAYER=$1
fi
echo "${TF_LAYER[@]}"

for layer in "${TF_LAYER[@]}"
do
 if [[ -z "$layer" ]]; then
    continue
  fi

cd $layer

terraform init 

terraform plan --out "tfplan"

if [[ "${PIPESTATUS[0]}" -ne "0" ]]; then exit 1 ; fi
  terraform apply -auto-approve ${TF_PLAN_FILE}
if [[ "${PIPESTATUS[0]}" -ne "0" ]]; then exit 1 ; fi
  set -e
  rm tfplan
  cd ..
done

