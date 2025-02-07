/*****************************************
 MySQL
*****************************************/

module "MySql" {
  source                       = "./modules/MySQL"
  project_id                   = var.project_id
  instance_name                = "test-instance"
  region                       = var.region
  tier                         = "db-f1-micro"
  network                      = module.vpc.vpc.self_link
  private_ip_address_name      = "private-ip"
  database_name                = "test-database"
  dbuser_name                  = "db-user"
  dbuser_password              = "db-password"
  depends_on = [ 
     module.vpc
  ] 
}
