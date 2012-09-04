#The type of system
# - :dedicated for a system where only MySQL is running
# - :shared for a system where MySQL is running alongside other components (e.g. Nginx, Memcache and so on)
default['mysql']['system_type']                             =   :shared

default['mysql']['perform_optimization']                    =   true
default['mysql']['optimize_based_on_system_memory']         =   true

default['mysql']['admin_user']                              =   {
  'username'    =>  nil,
  'password'    =>  nil
}

set['mysql']['tunable']['default-storage-engine']           =   'innodb'

set['mysql']['tunable']['connect_timeout']                  =   10
set['mysql']['tunable']['wait_timeout']                     =   180
set['mysql']['tunable']['interactive_timeout']              =   180

set['mysql']['tunable']['innodb_flush_log_at_trx_commit']   =   0
set['mysql']['tunable']['innodb_thread_concurrency']        =   10
set['mysql']['tunable']['innodb_flush_method']              =   'O_DIRECT'
set['mysql']['tunable']['innodb_file_per_table']            =   true
set['mysql']['tunable']['innodb_buffer_pool_size']          =   "128M"
set['mysql']['tunable']['innodb_additional_mem_pool_size']  =   "128M"
set['mysql']['tunable']['innodb_log_files_in_group']        =   2

set['mysql']['tunable']['innodb_log_buffer_size']           =   '8M'
set['mysql']['tunable']['innodb_log_file_size']             =   '128M'

#Because of file_per_table = true. See http://mysqldump.azundris.com/archives/78-Configuring-InnoDB-An-InnoDB-tutorial.html
set['mysql']['tunable']['innodb_data_file_path']            =   'ibdata1:10M:autoextend' 
set['mysql']['tunable']['innodb_autoextend_increment']      =   8

#Based on 1024mb system memory
set['mysql']['tunable']['query_cache_size']                 =   "256M"
set['mysql']['tunable']['query_cache_limit']                =   "128M"
set['mysql']['tunable']['tmp_table_size']                   =   "128M"
set['mysql']['tunable']['key_buffer_size']                  =   "32M"
set['mysql']['tunable']['read_buffer_size']                 =   "62M"
set['mysql']['tunable']['read_rnd_buffer_size']             =   "62M"
set['mysql']['tunable']['sort_buffer_size']                 =   "32M"
set['mysql']['tunable']['join_buffer_size']                 =   "32M"
set['mysql']['tunable']['bulk_insert_buffer_size']          =   "32M"