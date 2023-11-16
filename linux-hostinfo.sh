#!/usr/bin/bash

HOST_INFO_FILE=/etc/linux-hostinfo/hostinfo.yaml
PROVIDER=http://169.254.169.254/latest/meta-data/instance-id

AWS_INSTANCE_ID_URL=http://169.254.169.254/latest/meta-data/instance-id
LINODE_INSTANCE_ID_URL=TODO::this-service-needs-to-be-setup-by-us-if-this-is-needed


#function that get the public ip address of my machine and return it to the caller 
function get_public_ip_ipify() {
    curl -s https://api.ipify.org
}   

#function that get the public ip address of my machine and return it to the caller
function get_public_ip_aws() {
    curl -s  https://checkip.amazonaws.com/
}

# Function to check if a given IP is a valid IP address it returns true or false
function is_valid_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0
    else
        return 1
    fi
}

#try to get the private IP of VPC which usually starts with 10.0.
function get_private_ip() {
    vpc_ip_string=$(ip addr | grep "inet 10.0.")
    private_ip=$(awk '{print $2}' <<< "$vpc_ip_string" | sed 's/\/24//')
    echo $private_ip
}




#
# Create the yaml file
#
public_ip=$(get_public_ip_aws)

if ! is_valid_ip $public_ip; then
   public_ip=$(get_public_ip_ipify)
fi

private_ip=$(get_private_ip)
hostname=$(hostname)

instance_id=$(curl -s $AWS_INSTANCE_ID_URL)
provider=aws


#check if instance_id is empty, if so we must be on Linode / other cloud provider 
if [ -z "$instance_id" ]; then
    #check if we are on Linode or not
    sys_vendor_string=$(cat /sys/class/dmi/id/sys_vendor)
    #check if sysverndoer is Linode
    if [[ $sys_vendor_string == "Linode" ]]; then
        #TODO: instance id service needs to be implemented on our own
        instance_id=$(curl -s $LINODE_INSTANCE_ID_URL)
        provider=linode
    else
        echo "Not on AWS, Linode sorry"
        uuid=$(uuidgen)
        instance_id=unknown-$uuid
        provider=unknown
    fi  
fi

#write instance_id, provider, hostname, private_ip, public_ip to yaml file
cat << EOF > $HOST_INFO_FILE
instance_id: $instance_id
provider: $provider
hostname: $hostname
private_ip: $private_ip
public_ip: $public_ip
EOF

echo $HOST_INFO_FILE
