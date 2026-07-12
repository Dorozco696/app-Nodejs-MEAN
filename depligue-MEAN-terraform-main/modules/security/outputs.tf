output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "web_sg_id" {
  value = aws_security_group.web.id
}

output "db_sg_id" {
  value = aws_security_group.db.id
}

output "ssm_instance_profile_name" {
  value = aws_iam_instance_profile.ssm_profile.name
}

output "ssm_role_arn" {
  value = aws_iam_role.ssm_role.arn
}
