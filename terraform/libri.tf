

variable "n_librarians" {
  description = "current number of librarian peers in cluster"
}

variable "librarian_disk_size" {
  description = "size (GB) of persistant disk used by each librarian"
}

variable "public_port_start" {
  description = "starting public-facing libri port"
}

variable "librarian_disk_type" {
  description = "type of persistent disk used by each librarian"
  default = "pd-ssd"
}

resource "google_compute_disk" "data-librarians" {
  count = "${var.n_librarians}"
  name = "data-librarians-${count.index}"
  type = "${var.librarian_disk_type}"
  zone = "${var.zone}"
  size = "${var.librarian_disk_size}"
}

resource "google_compute_firewall" "libri-external" {
  description = "opens up ports for libri cluster communication to the outside world"
  name = "${var.cluster_name}"
  network = "default"

  allow {
    protocol = "tcp"
    ports = [
      "${var.public_port_start}-${var.public_port_start + var.n_librarians - 1}",  # Libri
      "30300",  # Grafana NodePort
      "30090",  # Prometheus NodePort
    ]
  }

  source_ranges = ["0.0.0.0/0"]
}