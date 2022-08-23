resource "aws_glue_catalog_database" "example" {
  name = "sadabate"
}

resource "aws_glue_catalog_table" "example" {
  name          = "abelt"
  database_name = aws_glue_catalog_database.test.name

  storage_descriptor {
    columns {
      name = "event"
      type = "string"
    }
  }
}

locals {
    column_data = file("${path.module}/requirement.txt")
    # column_data_read = [ for i in column_data: ]
}

locals {
  columns = flatten(local.column_data_read)
}

output {
    values = local.column_data_read
}

resource "aws_lakeformation_permissions" "example" {
  permissions = ["SELECT"]
  principal   = "*"

  table_with_columns {
    database_name = aws_glue_catalog_table.example.database_name
    name          = aws_glue_catalog_table.example.name
    column_names  = ["event"]
  }
}