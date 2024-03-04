#*********************************** Compartments,Identity Domain, ATP and OIC Gen 3 Configuration Part*********************************
module "PaaS-Cmp" {
  source = "./modules/IAM/compartment"
  tenancy_ocid             = var.tenancy_ocid
  compartment_id           = var.compartment_id
  compartment_name         = "PaaS-Cmp"
  compartment_description  = "Parent Compartment For PaaS Services"
  compartment_create       = true # if false, a data source with a matching name is created instead
  enable_delete            = true # if false, on `terraform destroy`, compartment is deleted from the terraform state but not from oci 
}

module "PaaS-Domain" {
  source                   = "./modules/IAM/IdentityDomain"
  compartment_id           = module.PaaS-Cmp.compartment_id
  description              = "Identity domain for non prod PaaS environments" 
  display_name             = "PaaS-Domain"                           
  home_region              = var.region
  license_type             = "free" 

  #Optional
  admin_email              = "terraformuser@gmail.com" 
  admin_first_name         = "Terraform"              
  admin_last_name          = "User"                  
  admin_user_name          = "terraformuser@gmail.com" 
  is_notification_bypassed = false
  depends_on               = [module.PaaS-Cmp]
}

module "PaaS-ATP" {
  source                                       = "./modules/Database/atp"
  compartment_id                               = module.PaaS-Cmp.compartment_id
  autonomous_database_admin_password           = "WelCome##123"
  autonomous_database_is_free_tier             = "false"
  autonomous_database_cpu_core_count           = "1"
  autonomous_database_data_storage_size_in_tbs = "1"
  autonomous_database_db_name                  = "terraformatp"
  autonomous_database_db_version               = "19c"
  autonomous_database_db_workload              = "OLTP"
  autonomous_database_display_name             = "terraformatp"
  autonomous_database_license_model            = "LICENSE_INCLUDED"
  depends_on                                   = [module.PaaS-Cmp]
}

module "PaaS-OIC" {
  source                                      = "./modules/PaaS/oic"
  compartment_id                              = module.PaaS-Cmp.compartment_id
  oic_display_name		                        = "terraformoic"
  oic_instance_type	                          = "ENTERPRISEX"
  oic_is_byol		                              = "false"
  oic_message_packs                           = "1"
  enable_file_server	                        = "false"
  enable_vbcs		                              = "false"
  oic_domain_id		                            = module.PaaS-Domain.domain_id
  depends_on                                  = [module.PaaS-Domain]
}