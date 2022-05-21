# animals list

data "archive_file" "lambda_post_production" {
  type        = "zip"
  source_dir  = "${path.module}/src/post_production"
  output_path = "${path.module}/src/post_production.zip"
}

resource "aws_lambda_function" "post_production" {
  publish          = true
  description      = "Post new production event"
  function_name    = "simplerp_post_production"
  runtime          = "python3.8"
  handler          = "post_production.lambda_handler"
  filename         = data.archive_file.lambda_post_production.output_path
  source_code_hash = data.archive_file.lambda_post_production.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
}
