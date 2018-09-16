resource "google_kms_key_ring" "libri" {
  name     = "${var.secrets_key_ring_name}"
  location = "${var.region}"
}

resource "google_kms_crypto_key" "libri-secrets" {
  name     = "${var.tf_secrets_key_name}"
  key_ring = "${google_kms_key_ring.libri.id}"
}
