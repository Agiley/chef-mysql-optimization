#The type of system
# - :dedicated for a system where only MySQL is running
# - :shared for a system where MySQL is running alongside other components (e.g. Nginx, Memcache and so on)
default['mysql']['system_type']                                 =   :shared

default['mysql']['perform_optimization']                        =   true

default['mysql']['admin_user']                                  =   {
  'username'    =>  nil,
  'password'    =>  nil
}

default['mysql']['tunable']['default-storage-engine']           =   'innodb'

default['mysql']['tunable']['enable_binary_logging']            =   false
default['mysql']['tunable']['server-id']                        =   1
default['mysql']['tunable']['log_bin']                          =   '/var/log/mysql/mysql-bin.log'

default['mysql']['tunable']['innodb_flush_log_at_trx_commit']   =   0
default['mysql']['tunable']['innodb_thread_concurrency']        =   10
default['mysql']['tunable']['innodb_flush_method']              =   'O_DIRECT'
default['mysql']['tunable']['innodb_file_per_table']            =   true
default['mysql']['tunable']['innodb_log_files_in_group']        =   2

#Because of file_per_table = true. See http://mysqldump.azundris.com/archives/78-Configuring-InnoDB-An-InnoDB-tutorial.html
default['mysql']['tunable']['innodb_data_file_path']            =   'ibdata1:10M:autoextend' 
default['mysql']['tunable']['innodb_autoextend_increment']      =   8

#Additional optimization settings (calculated based on the server's actual memory capacity) will be set using the optimize_mysql method.


