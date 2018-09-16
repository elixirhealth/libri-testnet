resource "google_project_iam_policy" "project" {
  project     = "${var.gcp_project}"
  policy_data = "${data.google_iam_policy.admin.policy_data}"
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/compute.storageAdmin"

    members = [
      "serviceAccount:libri-admin@elixir-deploy-staging-1.iam.gserviceaccount.com",
    ]
  }

  binding {
    role = "roles/compute.securityAdmin"

    members = [
      "serviceAccount:libri-admin@elixir-deploy-staging-1.iam.gserviceaccount.com",
    ]
  }

  binding {
    role = "roles/storage.objectAdmin"

    members = [
      "serviceAccount:libri-admin@elixir-deploy-staging-1.iam.gserviceaccount.com",
    ]
  }
}
