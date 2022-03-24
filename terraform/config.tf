locals {
  env          = "dev"
  prefix       = "${local.env}-${local.short_region}"
  region       = "europe-west1"
  project_id   = "stunning-yeti-341515"
  short_region = "euw1"
}

provider "google" {
  project = local.project_id
  region  = local.region
}
