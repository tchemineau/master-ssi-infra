locals {
  bucket_key    = "data.json"
  function_path = "${path.root}/../backend/gcp_function"
  function_name = "${local.prefix}-backend"
}

data "archive_file" "api_test_archive" {
  output_path = "${path.root}/.terraform/${local.env}/${local.function_name}.zip"
  source_dir  = local.function_path
  type        = "zip"
}

resource "google_storage_bucket_object" "api_test_archive" {
  name   = basename(data.archive_file.api_test_archive.output_path)
  bucket = google_storage_bucket.datastore_0.name
  source = data.archive_file.api_test_archive.output_path
}

resource "google_cloudfunctions_function" "api_test" {
  name        = local.function_name
  description = local.function_name
  runtime     = "python39"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket_object.api_test_archive.bucket
  source_archive_object = google_storage_bucket_object.api_test_archive.name
  trigger_http          = true
  entry_point           = "hello_http"

  environment_variables = {
    BUCKET_NAME = google_storage_bucket.datastore_0.name
    BUCKET_KEY = local.bucket_key
  }
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "api_test_invoker" {
  project        = google_cloudfunctions_function.api_test.project
  region         = google_cloudfunctions_function.api_test.region
  cloud_function = google_cloudfunctions_function.api_test.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_storage_bucket_object" "api_test_data" {
  name   = local.bucket_key
  bucket = google_storage_bucket.datastore_0.name
  content = "{}"
}
