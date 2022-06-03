#!/bin/bash
#update and upgrade Ubuntu
sudo apt update -y && sudo apt upgrade -y
#Packages need it for the installation
sudo apt install apt-transport-https curl nano
#Docker installation
sudo apt install docker.io -y
#Starting docker services
sudo systemctl start docker
sudo systemctl enable docker
#Adding signing key for repositories
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor > /etc/apt/trusted.gpg.d/kubernetes.gpg
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
#Kubernetes installation
sudo apt install kubeadm kubelet kubectl kubernetes-cni -y 
#Disable and editiong the swap
sudo swapoff -a
sudo sed -i 's/\/swap.img/#\/swap.img/g' /etc/fstab
#Initialize Kubernetes Master
sudo kubeadm init
#Master Node configuration
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#Deploy Flannel Network Pod
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
#Checking that all the PD are running
echo Please Wait
sleep 30s
kubectl get pods --all-namespaces
#displaying token
cat /etc/kubernetes/pki/token.csv
