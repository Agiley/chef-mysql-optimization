#include_recipe "mysql-optimization::secure_mysql" Deprecated: Already taken care of in primary mysql cookbook
include_recipe "mysql-optimization::create_admin_user"
include_recipe "mysql-optimization::optimize"