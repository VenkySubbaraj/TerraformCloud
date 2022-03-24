resource "aws_apprunner_connection" "apprunner_connection" {
  connection_name = "apprunner_connection"
  provider_type   = "GITHUB"

  tags = {
    Name = "apprunner-connection"
  }
}

#resource "aws_apprunner_service" "app_runner" {
#  service_name = "app_runner"

#  source_configuration {
#    authentication_configuration {
#      connection_arn = aws_apprunner_connection.apprunner_connection.arn
#    }
#    code_repository {
#      code_configuration {
#        code_configuration_values {
#          build_command = "python pip install -r requirements.txt"
#          port          = "8000"
#          runtime       = "PYTHON_3"
#          start_command = "python app.py"
#        }
#        configuration_source = "API"
#      }
#      repository_url = "public.ecr.aws/e3n8w8r2/publicrepo"
      #source_code_version {
      #  type  = "BRANCH"
      #  value = "master"
      #}
#    }
#  } 

#  tags = {
#    Name = "apprunner-service"
#  }
}

output "arnvalue" {
  value = aws_apprunner_connection.apprunner_connection.arn 
}
