output "EC2_sender_ID" {
  description = "ID of the EC2 sender"
  value       = aws_instance.ec2_sender_vector.id
}

output "EC2_sender_privateIP" {
  description = "Private IP address of the EC2 sender"
  value       = aws_instance.ec2_sender_vector.private_ip
}

output "EC2_receiver_ID" {
  description = "ID of the EC2 receiver"
  value       = aws_instance.ec2_receiver_vector.id
}

output "EC2_receiver_privateIP" {
  description = "Private IP address of the EC2 receiver"
  value       = aws_instance.ec2_receiver_vector.private_ip
}