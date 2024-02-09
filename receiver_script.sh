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