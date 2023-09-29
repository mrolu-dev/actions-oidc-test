resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id
}
resource "aws_vpc" "myvpc" {
  cidr_block = var.mycidr
  enable_dns_hostnames = true
  #domain     = vpc
  tags = {
    Name = var.vpcName
  }
}
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "192.168.0.0/26"
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.gw]


  tags = {
    Name = "subway"
    }
  }
resource "aws_network_interface" "netty" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["192.168.0.20"]

  tags = {
    Name = "primary_network_interface"
      }
    }
  


resource "aws_eip" "myEip" {
  #instance = aws_instance.myec2.id
  domain   = "vpc"
  network_interface = aws_network_interface.netty.id
  associate_with_private_ip  = "192.168.0.20"
  instance = aws_instance.myec2.id
  depends_on                = [aws_internet_gateway.gw]


  tags = {
    Name = "Demo-eip"
  }
}

  
resource "aws_instance" "myec2" {
  ami           = data.aws_ami.data.id
  instance_type = var.instance-type
  user_data     = file("${path.module}/http.sh")
  #subnet_id = aws_subnet.my_subnet.id
  network_interface {
    network_interface_id = aws_network_interface.netty.id
    device_index         = 0
  }
   credit_specification {
    cpu_credits = "unlimited"
  }
  tags = {
    Name = var.name
  }
}


