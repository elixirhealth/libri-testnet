resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}"
  initial_node_count = 1

  node_config {
    machine_type = "n1-standard-1"
    disk_size_gb = "${var.node_disk_size}"
  }

  master_auth {
    username = "admin"
    password = "${var.kubernetes_master_password}"
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --project ${var.gcp_project} --zone ${var.zone}"
  }
}

resource "google_container_node_pool" "n1-highmem-2" {
  name    = "n1-highmem-2"
  cluster = "${google_container_cluster.primary.id}"

  node_config {
    machine_type = "n1-highmem-2"
    disk_size_gb = "${var.node_disk_size}"
  }

  node_count = 2
}
