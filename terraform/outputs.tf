output "api_test_https_trigger_url" {
  value = google_cloudfunctions_function.api_test.https_trigger_url
}

output "api_test_bucket_datastore_url" {
  value = google_storage_bucket.datastore_0.self_link
}

output "api_test_bucket_website_url" {
  value = google_storage_bucket.website_0.self_link
}
