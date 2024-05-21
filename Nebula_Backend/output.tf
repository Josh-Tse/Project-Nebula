output "api-gataway-url" {
  value = aws_api_gateway_deployment.all-students-api-deployment.invoke_url
}