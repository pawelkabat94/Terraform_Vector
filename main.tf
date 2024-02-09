
resource "aws_security_group" "http_ssh_ec2_vector" {
  name        = "SecurityGroupEC2"
  description = "Security group for HTTP traffic and SSH"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_sender_vector" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "Sender"
  }

  key_name = "valuekeypair"
  security_groups = [aws_security_group.http_ssh_ec2_vector.name]
  user_data = <<-EOT
#!/bin/bash
bash -c "$(curl -L https://setup.vector.dev)"
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
yum install rsyslog -y
systemctl start rsyslog
systemctl enable rsyslog
yum install vector -y
systemctl start vector
systemctl enable vector
cd /etc/vector/
echo "
sources:
  my_syslog:
    type: file
    include:
      - /var/log/messages

transforms:
  add_id:
    inputs:
      - my_syslog
    type:  remap        
    source: |
     . = parse_syslog!(.message)
     .msgid = uuid_v4()
                          
                                                                                                                                                                       
sinks:
  my_sink_id:
    type: http
    inputs:
      - add_id
    uri: http://${aws_instance.ec2_receiver_vector.private_ip}:8080/
    encoding: 
     codec: json
    method: post
" > vector.yaml
vector
EOT
}

resource "aws_instance" "ec2_receiver_vector" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "Receiver"
  }

  key_name = "valuekeypair"
  security_groups = [aws_security_group.http_ssh_ec2_vector.name]
  user_data = <<-EOT
#!/bin/bash
bash -c "$(curl -L https://setup.vector.dev)"
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
yum install rsyslog -y
systemctl start rsyslog
systemctl enable rsyslog
yum install vector -y
systemctl start vector
systemctl enable vector
cd /etc/vector/
echo "
sources:
 my_source_id:
   type: http_server
   address: 0.0.0.0:8080
                                                                                                                                                    
sinks:                                                                                                                                                                     
  my_sink:
    type: file
    inputs:
     - my_source_id
    path: /tmp/vector.log
    encoding:              
     codec: json
" > vector.yaml
vector 
EOT
}