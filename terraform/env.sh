#!/usr/bin/env bash

# core infra
export TF_VAR_gcp_project="elixir-deploy-staging-1"
export TF_VAR_cluster_name="libri"
export TF_VAR_region="us-east1"
export TF_VAR_secrets_key_ring_name="libri"
export TF_VAR_tf_secrets_key_name="libri-tf-secrets"

# Libri
export TF_VAR_n_librarians=16
export TF_VAR_librarian_disk_size=25
export TF_VAR_public_port_start=30100
