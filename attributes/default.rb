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

default['mysql']['tunable']['connect_timeout']                  =   10
default['mysql']['tunable']['interactive_timeout']              =   180
#wait_timeout is defined in the original MySQL cookbook

default['mysql']['tunable']['enable_binary_logging']            =   false
default['mysql']['tunable']['server-id']                        =   1
default['mysql']['tunable']['log_bin']                          =   '/var/log/mysql/mysql-bin.log'

default['mysql']['tunable']['innodb_flush_log_at_trx_commit']   =   0
default['mysql']['tunable']['innodb_thread_concurrency']        =   10
default['mysql']['tunable']['innodb_flush_method']              =   'O_DIRECT'
default['mysql']['tunable']['innodb_file_per_table']            =   true
default['mysql']['tunable']['innodb_log_files_in_group']        =   2
default['mysql']['tunable']['innodb_log_buffer_size']           =   '4M'
default['mysql']['tunable']['innodb_log_file_size']             =   '128M'

#Because of file_per_table = true. See http://mysqldump.azundris.com/archives/78-Configuring-InnoDB-An-InnoDB-tutorial.html
default['mysql']['tunable']['innodb_data_file_path']            =   'ibdata1:10M:autoextend' 
default['mysql']['tunable']['innodb_autoextend_increment']      =   8

#For a 1024mb memory VPS
default['mysql']['tunable']['query_cache_size']                 =   "256M"
default['mysql']['tunable']['query_cache_limit']                =   "128M"
default['mysql']['tunable']['tmp_table_size']                   =   "128M"
default['mysql']['tunable']['key_buffer_size']                  =   "32M"
default['mysql']['tunable']['read_buffer_size']                 =   "62M"
default['mysql']['tunable']['read_rnd_buffer_size']             =   "62M"
default['mysql']['tunable']['sort_buffer_size']                 =   "32M"
default['mysql']['tunable']['join_buffer_size']                 =   "32M"
default['mysql']['tunable']['bulk_insert_buffer_size']          =   "32M"
                                                                                    
default['mysql']['tunable']['myisam_sort_buffer_size']          =   "62M"
default['mysql']['tunable']['myisam_max_sort_file_size']        =   "62M"
                                                                                    
default['mysql']['tunable']['innodb_additional_mem_pool_size']  =   "128M"
default['mysql']['tunable']['innodb_log_buffer_size']           =   "4M"
default['mysql']['tunable']['innodb_log_file_size']             =   "128M"