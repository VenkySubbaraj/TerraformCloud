
resource "aws_apprunner_connection" "apprunner_connection" {
  connection_name = "apprunner_connection"
  provider_type   = "GITHUB"

  tags = {
    Name = "apprunner-connection"
  }
}

resource "aws_apprunner_service" "app_runner" {
  service_name = "app_runner"

  source_configuration {
    authentication_configuration {
      connection_arn = aws_apprunner_connection.apprunner_connection.arn
    }
    code_repository {
      code_configuration {
        code_configuration_values {
          build_command = "python setup.py develop"
          port          = "8000"
          runtime       = "PYTHON_3"
          start_command = "python runapp.py"
        }
        configuration_source = "API"
      }
      repository_url = "https://github.com/VenkySubbaraj/TerraformCloud/"
      source_code_version {
        type  = "BRANCH"
        value = "master"
      }
    }
  }

  tags = {
    Name = "apprunner-service"
  }
}

