terraform {
  backend "gcs" {
    bucket      = "elixir-deploy-staging-1-clusters"
    prefix      = "libri/terraform"
    project     = "elixir-deploy-staging-1"
    region      = "us-east1"
    credentials = "gcp_credentials.json"
  }
}
