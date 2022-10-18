resource "aws_glue_catalog_database" "example" {
  name = "sadabate"
}

resource "aws_glue_catalog_table" "example" {
  name          = "abelt"
  database_name = aws_glue_catalog_database.example.name

  storage_descriptor {
    columns {
      name = "${local.column_data}"
      type = "string"
    }
  }
}

locals {
    column_data =split("/n", file("${path.module}/requirement.txt"))
    # column_data_read = [ for i in column_data: ]
}

# locals {
#   columns = flatten(local.column_data)
# }

# output "column_data_identification_flattern"{
#     value = local.columns
# }


output "column_data_identification"{
    value = local.column_data
}

resource "aws_lakeformation_permissions" "example" {
  permissions = ["SELECT"]
  principal   = "arn:aws:iam::780467203909:user/venkat"

  table_with_columns {
    database_name = aws_glue_catalog_table.example.database_name
    name          = aws_glue_catalog_table.example.name
    column_names  = [local.column_data]
  }
}
