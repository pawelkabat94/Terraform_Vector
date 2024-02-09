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
    uri: http://${aws_instance.ec2_receiver.private_ip}:8080/
    encoding: 
     codec: json
    method: post
" > vector.yaml
vector