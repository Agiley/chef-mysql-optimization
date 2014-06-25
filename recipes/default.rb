include_recipe "mysql::server"

include_attribute "mysql"
include_attribute "mysql::server"

include_recipe "mysql-optimization::secure_mysql"
include_recipe "mysql-optimization::create_admin_user"
include_recipe "mysql-optimization::optimize"