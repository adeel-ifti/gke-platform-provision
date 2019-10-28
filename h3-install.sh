#!/bin/bash

# update these variables
namespace=helmsummit
helmReleaseName=jenkins
helmVersion=helm-v3.0.0-alpha.1-linux-arm64.tar.gz 
# Setup Nginx Ingress controller - watch it fail

#stable 
# download helm version
wget https://get.helm.sh/$helmVersion
tar xvzf $helmVersion

# mv helm3 binary to local tmp folder
if [[ -e /usr/local/bin/tmp ]] ; then echo "tmp folder already exists" ; else mkdir /usr/local/bin/tmp ; fi
mv darwin-amd64/helm /usr/local/bin/tmp/helm

# TEMPORARY export $HELM_HOME so you don't overwrite Helm2 ~/.helm/
export HELM_HOME=/usr/local/bin/tmp/helm3

# set temp alias
h3=/usr/local/bin/tmp/helm

# add alias to .zshrc or .bashrc
echo "alias h3=/usr/local/bin/tmp/helm" >> ~/.zshrc
# echo "alias h3=/usr/local/bin/tmp/helm" >> ~/.bashrc

# cleanup
rm -rf $helmVersion
rm -rf darwin-amd64

# add helm repos
helm repo add stable http://storage.googleapis.com/kubernetes-charts
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator

# Setup Nginx Ingress controller
h3 upgrade --install nginx-ingress stable/nginx-ingress

# Setup Certificate Manger
##optional
kubectl apply \
    -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml

#add jetstack repo
h3 repo add jetstack https://charts.jetstack.io

#kubens and kubectx repo - https://github.com/ahmetb/kubectx | command: brew install kubectx
h3 upgrade --install cert-mgr jetstack/cert-manager -n kube-system

# Setup Certificate Cluster Issuer
kubectl apply -f cluster-issuer.yaml

#helm 2 still installed
helm version

#helm3-alpha1 alias
h3 version

#helm3-alpha1 list releases
h3 ls

#helm3-alpha1 list all releases
h3 ls --all-namespaces

#quick change namespace back to default (get out of kube-system)
kubens default

# kubeval plugin insstall
h3 plugin install https://github.com/instrumenta/helm-kubeval

# check XDG cache path
# linux:
ls $HOME/.cache/helm
#macOS:
ls $HOME/Library/Caches/helm/

# Test configuration - Demo!
h3 upgrade jenkins --install --namespace $namespace -f ./jenkins-values-demo.yaml stable/jenkins

# h3 repo add
h3 repo add jdcharts https://jdk8s.blob.core.windows.net/helm/

# crochunter
h3 upgrade crochunter --install --namespace default --set ingress.hostname=crochunter.h3.az.jessicadeen.com,image=jldeen/croc-hunter,imageTag=0.3.1 jdcharts/croc-hunter

# get pods in specified namespace
kubectl get pods -n $namespace

#command to get admin password
 printf $(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

# helm2to3 plugin (install using helm2)
helm plugin install https://github.com/helm/helm-2to3

# convert helm2 to helm3 release
helm 2to3 convert --dry-run RELEASE
