

resource "aws_lambda_function" "all-students-lambda-function" {
  image_uri     = var.lambda-image-uri
  function_name = "all-students"
  role          = aws_iam_role.iam-role-for-lambda.arn
  handler       = "all-students.handler"


  runtime = "python3.9"


}