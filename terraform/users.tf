locals {
  # Authorize Google Account only
  users = [
    "user:mon.addresse@example.com",
  ]
}

resource "google_project_iam_binding" "project" {
  project = local.project_id
  role    = "roles/editor"

  members = local.users
}

# Could be required to grant allUser attachment. To be fine-grained.
resource "google_project_iam_binding" "project_iam_admin" {
  project = local.project_id
  role    = "roles/iam.securityAdmin"

  members = []
}
