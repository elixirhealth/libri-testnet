#!/usr/bin/env bash

export TF_VAR_gcp_project="elixir-deploy-staging-1"
export TF_VAR_cluster_name="libri"
export TF_VAR_region="us-east1"

export TF_VAR_secrets_key_ring_name="libri"
export TF_VAR_tf_secrets_key_name="libri-tf-secrets"
