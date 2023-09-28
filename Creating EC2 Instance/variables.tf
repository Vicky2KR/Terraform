variable "security_group1" {
  type = string
  description = "Allow RDP"
}

variable "ami1" {
 type = string
 description = "Provide the ami id"
}

variable "instance_type1" {
   type = string
   description = "Size of the instance"
}

variable "a_key" {
  default = "**************************"
}

variable "s_key" {
  default = "******************************************"
}
