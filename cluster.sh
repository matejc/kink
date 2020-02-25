#!/bin/sh

TERMINAL="${TERMINAL-"xfce4-terminal"}"
VMUSER=${VMUSER-ubuntu}

vm_help() {
    echo "$0 <status|start|reboot|suspend|resume|shutdown|install|net-restart> [args]".
}

if [ -z "$1" ] ;
then
    vm_help
    exit 1
fi

virsh_func() {
    virsh $1 k8s-master "${@:2}"
    virsh $1 k8s-node1 "${@:2}"
    virsh $1 k8s-node2 "${@:2}"
}

case $1 in
start|reboot|suspend|resume|shutdown|snapshot-list|snapshot-restore|snapshot-delete)
    virsh_func "$1" "${@:2}"
    ;;
status)
    virsh net-dhcp-leases nat223
    virsh list
    ;;
install)
    ./.createvm.sh "$1"
    ;;
net-restart)
    ./.net-restart.sh
    ;;
snapshot-create)
    virsh_func snapshot-create-as
    ;;
terminals)
    $TERMINAL -e "ssh $VMUSER@192.168.223.143"
    $TERMINAL -e "ssh $VMUSER@192.168.223.144"
    $TERMINAL -e "ssh $VMUSER@192.168.223.145"
    ;;
*)
    vm_help
    ;;
esac
