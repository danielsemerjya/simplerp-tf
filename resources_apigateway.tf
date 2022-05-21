resource "aws_api_gateway_rest_api" "simplerp_rest_api" {
  name = "simplerp_rest_api"
}

resource "aws_api_gateway_deployment" "simplerp_rest_api" {
  rest_api_id = aws_api_gateway_rest_api.simplerp_rest_api.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.production.id,
      aws_api_gateway_method.post_production.id,
      aws_api_gateway_integration.post_production.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "simplerp_rest_api" {
  depends_on    = [aws_cloudwatch_log_group.simplerp_rest_api]
  deployment_id = aws_api_gateway_deployment.simplerp_rest_api.id
  rest_api_id   = aws_api_gateway_rest_api.simplerp_rest_api.id
  stage_name    = var.stage_name
}

resource "aws_api_gateway_method_settings" "simplerp_rest_api" {
  rest_api_id = aws_api_gateway_rest_api.simplerp_rest_api.id
  stage_name  = aws_api_gateway_stage.simplerp_rest_api.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_resource" "production" {
  parent_id   = aws_api_gateway_rest_api.simplerp_rest_api.root_resource_id
  path_part   = "production"
  rest_api_id = aws_api_gateway_rest_api.simplerp_rest_api.id
}

resource "aws_api_gateway_method" "post_production" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.production.id
  rest_api_id   = aws_api_gateway_rest_api.simplerp_rest_api.id
}

resource "aws_api_gateway_integration" "post_production" {
  rest_api_id             = aws_api_gateway_rest_api.simplerp_rest_api.id
  resource_id             = aws_api_gateway_resource.production.id
  http_method             = aws_api_gateway_method.post_production.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.post_production.invoke_arn
}

