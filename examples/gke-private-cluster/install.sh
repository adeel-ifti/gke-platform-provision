#!/bin/bash


gcloud auth activate-service-account --key-file /dt-infra/gke-platform-provision/examples/gke-private-cluster/gcloud-sa.json
gcloud beta container clusters get-credentials ${CLUSTER_NAME} --region ${REGION} --project ${PROJECT_ID}
helm upgrade --install nginx-ingress stable/nginx-ingress --namespace nginx-ingress
