resource "aws_cloudwatch_log_group" "post_production" {
  name              = "/aws/lambda/${aws_lambda_function.post_production.function_name}"
  retention_in_days = 5
}

resource "aws_cloudwatch_log_group" "simplerp_rest_api" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.simplerp_rest_api.id}/${var.stage_name}"
  retention_in_days = 5
}