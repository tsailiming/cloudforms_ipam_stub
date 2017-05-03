Introduction
===

This is a stub integration with IPAM using the acquire_ip_method for Linux for VMware.

I have not tested this with others providers.

The VM template is required to have open-vm-tools installed and enabled. 

How to create the Service Catalog
===
* [Import](https://github.com/rhtconsulting/cfme-rhconsulting-scripts) the service dialog and automation code
* Add a new Service Catalog Item with a VMware Catalog Item Type
* Under [Request Info](images/request.png), choose Specification as the Customize option. 
* You don't have to select Custom Specification. Just select <None>.

After the VM is provisioned, the network information will be set:

```
[root@test etc]# cat /etc/sysconfig/network-scripts/ifcfg-eth0 
HWADDR=00:50:56:99:7b:06
NAME=eth0
GATEWAY=192.168.0.1
DNS1=8.8.8.8
DOMAIN=example.com
DEVICE=eth0
ONBOOT=yes
USERCTL=no
BOOTPROTO=static
NETMASK=255.255.0.0
IPADDR=192.168.1.88
PEERDNS=no

check_link_down() {
 return 1; 
}

[root@test etc]# cat /etc/sysconfig/network
NETWORKING=yes
HOSTNAME=test

[root@test etc]# cat /etc/resolv.conf 
search	example.com
nameserver	8.8.8.8

[root@test etc]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4

192.168.1.88	test.example.com test

[root@test etc]# hostname -f
test.example.com
```