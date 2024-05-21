resource "aws_api_gateway_rest_api" "all-students-api" {

  name        = "all-students-api"
  description = "api resourse linking the all-students lambda funtion to the front end "
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_resource" "all-students-resource" {
  rest_api_id = aws_api_gateway_rest_api.all-students-api.id
  parent_id   = aws_api_gateway_rest_api.all-students-api.root_resource_id
  path_part   = "students"
}



resource "aws_api_gateway_method" "students-method" {
  rest_api_id   = aws_api_gateway_rest_api.all-students-api.id
  resource_id   = aws_api_gateway_resource.all-students-resource.id
  http_method   = "GET"
  authorization = "NONE"
}



resource "aws_api_gateway_integration" "lambda-integration" {
  rest_api_id = aws_api_gateway_rest_api.all-students-api.id
  resource_id = aws_api_gateway_resource.all-students-resource.id
  http_method = aws_api_gateway_method.students-method.http_method
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.all-students-lambda-function.invoke_arn
}

resource "aws_lambda_permission" "student-api-GT" {
  statement_id  = "AllowExecutiionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.all-students-lambda-function.all-students
  principal     = "apigateway.amazon.com"
  source_arn    = "arn:aws:execute-api:${var.my-region}:${var.aws-account-ID}:${aws_api_gateway_rest_api.all-students-api.id}/*/${aws_api_gateway_method.students-method.http_method}${aws_api_gateway_resource.all-students-resource.path}"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.all-students-api.id
  resource_id = aws_api_gateway_resource.all-students-resource.id
  http_method = aws_api_gateway_method.students-method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "integration-response" {
  rest_api_id = aws_api_gateway_rest_api.all-students-api.id
  resource_id = aws_api_gateway_resource.all-students-resource.id
  http_method = aws_api_gateway_method.students-method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  depends_on = [
    aws_api_gateway_integration.lambda-integration
  ]

  response_templates = {
    "application/xml" = <<EOF
#set($inputRoot = $input.path('$'))
<?xml version="1.0" encoding="UTF-8"?>
<message>
    $inputRoot.body
</message>
EOF
  }
}

resource "aws_api_gateway_deployment" "all-students-api-deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda-integration
  ]
  rest_api_id = aws_api_gateway_rest_api.all-students-api.id
  stage_name  = "dev"
}
