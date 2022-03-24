resource "google_storage_bucket" "datastore_0" {
  name     = "${local.prefix}-datastore-0"
  location = local.region
}

resource "google_storage_bucket_iam_binding" "datastore_0_public_rule" {
  bucket = google_storage_bucket.datastore_0.name
  role = "roles/storage.objectViewer"
  members = [
    "allUsers"
  ]
}

resource "google_storage_bucket" "website_0" {
  name = "${local.prefix}-website-0"

  force_destroy               = true
  location                    = local.region
  uniform_bucket_level_access = true

  cors {
    origin          = ["http://example.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_iam_binding" "website_0_public_rule" {
  bucket = google_storage_bucket.website_0.name
  role = "roles/storage.objectViewer"
  members = [
    "allUsers"
  ]
}
