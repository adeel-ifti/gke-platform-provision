#!/bin/bash


gcloud auth activate-service-account --key-file $(pwd)/gcloud-sa.json
gcloud beta container clusters get-credentials ${CLUSTER_NAME} --region ${REGION} --project ${PROJECT_ID}
helm upgrade --install nginx-ingress stable/nginx-ingress --namespace nginx-ingress
