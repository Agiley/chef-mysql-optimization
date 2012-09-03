#The type of system
# - :dedicated for a system where only MySQL is running
# - :shared for a system where MySQL is running alongside other components (e.g. Nginx, Memcache and so on)
default['mysql']['system_type']                                 =   :shared

default['mysql']['perform_optimization']                        =   true

default['mysql']['admin_user']                                  =   {
  'username'    =>  nil,
  'password'    =>  nil
}

override['mysql']['tunable']['default-storage-engine']           =   'innodb'

override['mysql']['tunable']['connect_timeout']                  =   10
override['mysql']['tunable']['interactive_timeout']              =   180
#wait_timeout is defined in the original MySQL cookbook

override['mysql']['tunable']['enable_binary_logging']            =   false
override['mysql']['tunable']['server-id']                        =   1
override['mysql']['tunable']['log_bin']                          =   '/var/log/mysql/mysql-bin.log'

override['mysql']['tunable']['innodb_flush_log_at_trx_commit']   =   0
override['mysql']['tunable']['innodb_thread_concurrency']        =   10
override['mysql']['tunable']['innodb_flush_method']              =   'O_DIRECT'
override['mysql']['tunable']['innodb_file_per_table']            =   true
override['mysql']['tunable']['innodb_log_files_in_group']        =   2
override['mysql']['tunable']['innodb_log_buffer_size']           =   '4M'
override['mysql']['tunable']['innodb_log_file_size']             =   '128M'
override['mysql']['tunable']['innodb_additional_mem_pool_size']  =   "128M"

#Because of file_per_table = true. See http://mysqldump.azundris.com/archives/78-Configuring-InnoDB-An-InnoDB-tutorial.html
override['mysql']['tunable']['innodb_data_file_path']            =   'ibdata1:10M:autoextend' 
override['mysql']['tunable']['innodb_autoextend_increment']      =   8

#For a 1024mb memory VPS
override['mysql']['tunable']['query_cache_size']                 =   "256M"
override['mysql']['tunable']['query_cache_limit']                =   "128M"
override['mysql']['tunable']['tmp_table_size']                   =   "128M"
override['mysql']['tunable']['key_buffer_size']                  =   "32M"
override['mysql']['tunable']['read_buffer_size']                 =   "62M"
override['mysql']['tunable']['read_rnd_buffer_size']             =   "62M"
override['mysql']['tunable']['sort_buffer_size']                 =   "32M"
override['mysql']['tunable']['join_buffer_size']                 =   "32M"
override['mysql']['tunable']['bulk_insert_buffer_size']          =   "32M"
                                                                                    
override['mysql']['tunable']['myisam_sort_buffer_size']          =   "62M"
override['mysql']['tunable']['myisam_max_sort_file_size']        =   "62M"