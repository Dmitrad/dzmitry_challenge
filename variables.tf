#vpc variables
##################################################
variable "vpc_cidr_block" {
  type    = string
  default = "10.4.0.0/16"
}

variable "subnet_cidr_block_1" {

  default = "10.4.5.0/24"
}

variable "zone1" {
  default = "us-east-1a"
}

variable "subnet_cidr_block_2" {

  default = "10.4.3.0/24"
}

variable "zone2" {
  default = "us-east-1b"
}

#VARIABLES EC2
#####################################################
variable "ssh_key_name" {
  description = "key to use for ssh"
  type        = string
  default     = "dzmitry-awskey"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "user_data_file" {
  type    = string
  default = "userdata.sh"
}

variable "tag_images" {
  type = string
  default = "images"
 
}

#VARIABLE SG
########################################
variable "sg_cidrs" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}

