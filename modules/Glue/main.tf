
resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = "MyCatalogDatabase"
}

resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
  name          = "MyCatalogTable"
  database_name = "MyCatalogDatabase"

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      = "s3://my-bucket/event-streams/my-stream"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "my-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    dynamic.columns {
        for_each = var.cloumns_names
      name = columns_names.file("${path.module}/data.txt")
      type = columns_name.file("${path.module}/data.txt")
    }