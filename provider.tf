terraform {
  required_version = ">=1.2.2" // this example is intended to run with Terraform v0.12
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">=4.112.0" // force downloading oci-provider compatible with terraform v0.12
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = pathexpand(var.private_key_path)
  region           = var.region

}

