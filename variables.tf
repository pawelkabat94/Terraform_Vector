variable "ami" {
  description = "Linux image to use for EC2 instance"
  type        = string
  default     = "ami-018ba43095ff50d08"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}