lambda_functions = [
  {
    count         = 1
    source_file   = "./lambda_function1.py"
    output_path   = "./lambda_function1.zip"
    function_name = "ip-usage-checker"
    handler       = "lambda_function.lambda_handler"
  },
#   {
#     source_file   = "./lambda_function2.py"
#     output_path   = "./lambda_function2.zip"
#     function_name = "ip-usage-checker-1"
#     handler       = "lambda_function.lambda_handler"
#   },

]



#  default = {
#     "lambda1" = {
#       source_file   = "./src/lambda_function1.py"
#       output_path   = "./src/lambda_function1.zip"
#       function_name = "ip-usage-checker-1"
#       handler       = "lambda_function1.lambda_handler"
#     },
#     "lambda2" = {
#       source_file   = "./src/lambda_function2.py"
#       output_path   = "./src/lambda_function2.zip"
#       function_name = "ip-usage-checker-2"
#       handler       = "lambda_function2.lambda_handler"
#     }
#   }
# }