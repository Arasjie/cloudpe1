# variables.tf

variable "region" {
     default = "us-east-1"
}

variable "availabilityZone" {
     default = "us-east-1a"
}

variable "availabilityZoneb" {
     default = "us-east-1b"
}

variable "availabilityZonec" {
     default = "us-east-1c"
}

variable "instanceTenancy" {
    default = "default"
}

variable "dnsSupport" {
    default = true
}

variable "dnsHostNames" {
    default = true
}

variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}

variable "vpcCIDRblock" {
    default = "172.31.0.0/16"
}

variable "subnetCIDRblock" {
    default = "172.31.1.0/24"
}

variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}

variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}

variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}

variable "mapPublicIP" {
    default = true
}

# end of variables.tf