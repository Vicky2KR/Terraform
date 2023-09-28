resource "aws_vpc" "test_vpc" {
  
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "test-vpc"
}
}
resource "aws_subnet" "private_subnets1" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "test-subnet1"
  }
}

resource "aws_instance" "ec2" {
    ami = var.ami1
    subnet_id = aws_subnet.private_subnets1.id
    instance_type = var.instance_type1
    user_data = <<-EOF
          <powershell>
           net user tempuser tempa@1234 /add
           net localgroup administrators tempuser /add
          </powershell>
          EOF
    tags = {
        Name = "test-ec2"
    }

     security_groups = [ "${aws_security_group.allow_tls.id}" ] # Replace with your security group ID

} 

resource "aws_eip_association" "example" {
  instance_id = aws_instance.ec2.id
  allocation_id = aws_eip.public_ip.id
}
