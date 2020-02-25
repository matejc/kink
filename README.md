# kink
Kubernetes in KVM


## Networking

virsh net-define nat223.xml
virsh net-start nat223
virsh net-autostart nat223


## Create VMs

./cluster.sh install k8s-master
./cluster.sh install k8s-node1
./cluster.sh install k8s-node2


### Note 

For each installation, set at least:
- User named **ubuntu**
- Corresponding **hostname** (for k8s-master set k8s-master as hostname)


## Docker Installation

Ssh into each machine and do **sudo su -** and then:

    apt-get update
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io


## K8s

### Installation

    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | \
        sudo tee /etc/apt/sources.list.d/kubernetes.list
    apt-get update
    apt-get install -y kubelet kubeadm kubectl
    apt-mark hold kubelet kubeadm kubectl


### Configuration - master

    kubeadm init --pod-network-cidr=10.244.0.0/16

### Configuration - worker nodes

    master# kubeadm token create --print-join-command
    node1# kubeadm join ...
    node2# kubeadm join ...

