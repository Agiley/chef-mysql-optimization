#The type of system
# - :dedicated for a system where only MySQL is running
# - :shared for a system where MySQL is running alongside other components (e.g. Nginx, Memcache and so on)
default['mysql']['system_type']                             =   :shared

default['mysql']['perform_optimization']                    =   true
default['mysql']['optimization_based_on_system_memory']     =   true

default['mysql']['admin_user']                              =   {
  'username'    =>  nil,
  'password'    =>  nil
}

# Included from original server attributes for mysql cookbook
default['mysql']['bind_address']               = (node.attribute?('cloud') && node['cloud']['local_ipv4']) ? node['cloud']['local_ipv4'] : node['ipaddress']
default['mysql']['port']                       = '3306'
default['mysql']['nice']                       = 0

case node["platform_family"]
when "debian"
  default['mysql']['server']['packages']      = %w{mysql-server}
  default['mysql']['service_name']            = "mysql"
  default['mysql']['basedir']                 = "/usr"
  default['mysql']['data_dir']                = "/var/lib/mysql"
  default['mysql']['root_group']              = "root"
  default['mysql']['mysqladmin_bin']          = "/usr/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/bin/mysql"
  default['mysql']['mysql_upgrade_bin']       = "/usr/bin/mysql_upgrade"

  default['mysql']['conf_dir']                    = '/etc/mysql'
  default['mysql']['confd_dir']                   = '/etc/mysql/conf.d'
  default['mysql']['socket']                      = "/var/run/mysqld/mysqld.sock"
  default['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  default['mysql']['old_passwords']               = 0
  default['mysql']['grants_path']                 = "/etc/mysql/grants.sql"
when "rhel", "fedora", "suse"
  if node["mysql"]["version"].to_f >= 5.5
    default['mysql']['service_name']            = "mysql"
    default['mysql']['pid_file']                    = "/var/run/mysql/mysql.pid"
  else
    default['mysql']['service_name']            = "mysqld"
    default['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  end
  default['mysql']['server']['packages']      = %w{mysql-server}
  default['mysql']['basedir']                 = "/usr"
  default['mysql']['data_dir']                = "/var/lib/mysql"
  default['mysql']['root_group']              = "root"
  default['mysql']['mysqladmin_bin']          = "/usr/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/bin/mysql"
  default['mysql']['mysql_upgrade_bin']       = "/usr/bin/mysql_upgrade"

  default['mysql']['conf_dir']                    = '/etc'
  default['mysql']['confd_dir']                   = '/etc/mysql/conf.d'
  default['mysql']['socket']                      = "/var/lib/mysql/mysql.sock"
  default['mysql']['old_passwords']               = 1
  default['mysql']['grants_path']                 = "/etc/mysql_grants.sql"
  # RHEL/CentOS mysql package does not support this option.
  default['mysql']['tunable']['innodb_adaptive_flushing'] = false
when "freebsd"
  default['mysql']['server']['packages']      = %w{mysql55-server}
  default['mysql']['service_name']            = "mysql-server"
  default['mysql']['basedir']                 = "/usr/local"
  default['mysql']['data_dir']                = "/var/db/mysql"
  default['mysql']['root_group']              = "wheel"
  default['mysql']['mysqladmin_bin']          = "/usr/local/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/local/bin/mysql"

  default['mysql']['conf_dir']                    = '/usr/local/etc'
  default['mysql']['confd_dir']                   = '/usr/local/etc/mysql/conf.d'
  default['mysql']['socket']                      = "/tmp/mysqld.sock"
  default['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  default['mysql']['old_passwords']               = 0
  default['mysql']['grants_path']                 = "/var/db/mysql/grants.sql"
when "windows"
  default['mysql']['server']['packages']      = ["MySQL Server 5.5"]
  default['mysql']['version']                 = '5.5.21'
  default['mysql']['arch']                    = 'win32'
  default['mysql']['package_file']            = "mysql-#{mysql['version']}-#{mysql['arch']}.msi"
  default['mysql']['url']                     = "http://www.mysql.com/get/Downloads/MySQL-5.5/#{mysql['package_file']}/from/http://mysql.mirrors.pair.com/"

  default['mysql']['service_name']            = "mysql"
  default['mysql']['basedir']                 = "#{ENV['SYSTEMDRIVE']}\\Program Files (x86)\\MySQL\\#{mysql['server']['packages'].first}"
  default['mysql']['data_dir']                = "#{node['mysql']['basedir']}\\Data"
  default['mysql']['bin_dir']                 = "#{node['mysql']['basedir']}\\bin"
  default['mysql']['mysqladmin_bin']          = "#{node['mysql']['bin_dir']}\\mysqladmin"
  default['mysql']['mysql_bin']               = "#{node['mysql']['bin_dir']}\\mysql"

  default['mysql']['conf_dir']                = node['mysql']['basedir']
  default['mysql']['old_passwords']           = 0
  default['mysql']['grants_path']             = "#{node['mysql']['conf_dir']}\\grants.sql"
when "mac_os_x"
  default['mysql']['server']['packages']      = %w{mysql}
  default['mysql']['basedir']                 = "/usr/local/Cellar"
  default['mysql']['data_dir']                = "/usr/local/var/mysql"
  default['mysql']['root_group']              = "admin"
  default['mysql']['mysqladmin_bin']          = "/usr/local/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/local/bin/mysql"
else
  default['mysql']['server']['packages']      = %w{mysql-server}
  default['mysql']['service_name']            = "mysql"
  default['mysql']['basedir']                 = "/usr"
  default['mysql']['data_dir']                = "/var/lib/mysql"
  default['mysql']['root_group']              = "root"
  default['mysql']['mysqladmin_bin']          = "/usr/bin/mysqladmin"
  default['mysql']['mysql_bin']               = "/usr/bin/mysql"
  default['mysql']['mysql_upgrade_bin']       = "/usr/bin/mysql_upgrade"

  default['mysql']['conf_dir']                    = '/etc/mysql'
  default['mysql']['confd_dir']                   = '/etc/mysql/conf.d'
  default['mysql']['socket']                      = "/var/run/mysqld/mysqld.sock"
  default['mysql']['pid_file']                    = "/var/run/mysqld/mysqld.pid"
  default['mysql']['old_passwords']               = 0
  default['mysql']['grants_path']                 = "/etc/mysql/grants.sql"
end

if attribute?('ec2')
  default['mysql']['ec2_path']    = "/mnt/mysql"
  default['mysql']['ebs_vol_dev'] = "/dev/sdi"
  default['mysql']['ebs_vol_size'] = 50
end

default['mysql']['reload_action'] = "restart" # or "reload" or "none"

default['mysql']['use_upstart'] = node['platform'] == "ubuntu" && node['platform_version'].to_f >= 10.04

default['mysql']['auto-increment-increment']        = 1
default['mysql']['auto-increment-offset']           = 1

default['mysql']['allow_remote_root']               = false
default['mysql']['tunable']['back_log']             = "128"
default['mysql']['tunable']['key_buffer']           = "256M"
default['mysql']['tunable']['myisam_sort_buffer_size']   = "8M"
default['mysql']['tunable']['myisam_max_sort_file_size'] = "2147483648"
default['mysql']['tunable']['myisam_repair_threads']     = "1"
default['mysql']['tunable']['myisam_recover']            = "BACKUP"
default['mysql']['tunable']['max_allowed_packet']   = "16M"
default['mysql']['tunable']['max_connections']      = "800"
default['mysql']['tunable']['max_connect_errors']   = "10"
default['mysql']['tunable']['concurrent_insert']    = "2"
default['mysql']['tunable']['connect_timeout']      = "10"
default['mysql']['tunable']['tmp_table_size']       = "128M"
default['mysql']['tunable']['max_heap_table_size']  = node['mysql']['tunable']['tmp_table_size']
default['mysql']['tunable']['bulk_insert_buffer_size'] = node['mysql']['tunable']['tmp_table_size']
default['mysql']['tunable']['myisam_recover']       = "BACKUP"
default['mysql']['tunable']['net_read_timeout']     = "30"
default['mysql']['tunable']['net_write_timeout']    = "30"
default['mysql']['tunable']['table_cache']          = "128"

default['mysql']['tunable']['thread_cache']         = "128"
default['mysql']['tunable']['thread_cache_size']    = 8
default['mysql']['tunable']['thread_concurrency']   = 10
default['mysql']['tunable']['thread_stack']         = "256K"
default['mysql']['tunable']['sort_buffer_size']     = "32M"
default['mysql']['tunable']['read_buffer_size']     = "32M"
default['mysql']['tunable']['read_rnd_buffer_size'] = "32M"
default['mysql']['tunable']['join_buffer_size']     = "16M"
default['mysql']['tunable']['wait_timeout']         = "180"
default['mysql']['tunable']['open-files-limit']     = "8192"
default['mysql']['tunable']['open-files']           = "1024"

default['mysql']['tunable']['sql_mode'] = nil

default['mysql']['tunable']['skip-character-set-client-handshake']  =   false
default['mysql']['tunable']['skip-name-resolve']                    =   false

default['mysql']['tunable']['server_id']                            =   nil
default['mysql']['tunable']['log_bin']                              =   nil
default['mysql']['tunable']['log_bin_trust_function_creators']      =   false

default['mysql']['tunable']['relay_log']                            =   nil
default['mysql']['tunable']['relay_log_index']                      =   nil
default['mysql']['tunable']['log_slave_updates']                    =   false

default['mysql']['tunable']['sync_binlog']                          =   0
default['mysql']['tunable']['skip_slave_start']                     =   false
default['mysql']['tunable']['read_only']                            =   false

default['mysql']['tunable']['log_error']                            =   nil
default['mysql']['tunable']['log_warnings']                         =   false
default['mysql']['tunable']['log_queries_not_using_index']          =   1
default['mysql']['tunable']['log_bin_trust_function_creators']      =   false

# This will be used to drop and re-create the InnoDB Table Space when modifying log file size etc.
default['mysql']['tunable']['innodb_tablespace_tables']             =   %w{
  innodb_index_stats
  innodb_table_stats
  slave_master_info
  slave_relay_log_info
  slave_worker_info
}

default['mysql']['tunable']['innodb_log_file_size']                 =   "128M"
default['mysql']['tunable']['innodb_buffer_pool_size']              =   "128M"
default['mysql']['tunable']['innodb_buffer_pool_instances']         =   "4"
default['mysql']['tunable']['innodb_additional_mem_pool_size']      =   "128M"
default['mysql']['tunable']['innodb_data_file_path']                =   "ibdata1:10M:autoextend"
default['mysql']['tunable']['innodb_flush_method']                  =   'O_DIRECT'
default['mysql']['tunable']['innodb_log_buffer_size']               =   "8M"
default['mysql']['tunable']['innodb_write_io_threads']              =   "4"
default['mysql']['tunable']['innodb_io_capacity']                   =   "200"
default['mysql']['tunable']['innodb_file_per_table']                =   true
default['mysql']['tunable']['innodb_lock_wait_timeout']             =   "60"
if node['cpu'].nil? or node['cpu']['total'].nil?
  default['mysql']['tunable']['innodb_thread_concurrency']          =   "8"
  default['mysql']['tunable']['innodb_commit_concurrency']          =   "8"
  default['mysql']['tunable']['innodb_read_io_threads']             =   "8"
  default['mysql']['tunable']['innodb_flush_log_at_trx_commit']     =   "8"
else
  default['mysql']['tunable']['innodb_thread_concurrency']          =   "#{(Integer(node['cpu']['total'])) * 2}"
  default['mysql']['tunable']['innodb_commit_concurrency']          =   "#{(Integer(node['cpu']['total'])) * 2}"
  default['mysql']['tunable']['innodb_read_io_threads']             =   "#{(Integer(node['cpu']['total'])) * 2}"
  default['mysql']['tunable']['innodb_flush_log_at_trx_commit']     =   "#{(Integer(node['cpu']['total'])) * 2}"
end
default['mysql']['tunable']['innodb_support_xa']                    =   true
default['mysql']['tunable']['innodb_table_locks']                   =   true
default['mysql']['tunable']['skip-innodb-doublewrite']              =   false

default['mysql']['tunable']['transaction-isolation']                =   nil

default['mysql']['tunable']['query_cache_limit']                    =   "128M"
default['mysql']['tunable']['query_cache_size']                     =   "256M"

default['mysql']['tunable']['slow_query_log']                       =   1
default['mysql']['tunable']['slow_query_log_file']                  =   "/var/log/mysql/slow.log"
default['mysql']['tunable']['long_query_time']                      =   10

default['mysql']['tunable']['expire_logs_days']                     =   10
default['mysql']['tunable']['max_binlog_size']                      =   "100M"
default['mysql']['tunable']['binlog_cache_size']                    =   "32K"

default['mysql']['tmpdir']                                          =   ["/tmp"]
default['mysql']['read_only']                                       =   false

default['mysql']['log_dir']                                         =   node['mysql']['data_dir']
default['mysql']['log_files_in_group']                              =   false
default['mysql']['innodb_status_file']                              =   false

unless node['platform_family'] && node['platform_version'].to_i < 6
  # older RHEL platforms don't support these options
  default['mysql']['tunable']['event_scheduler']                    =   0
  default['mysql']['tunable']['table_open_cache']                   =   "128"
  default['mysql']['tunable']['binlog_format']                      =   "statement" if node['mysql']['tunable']['log_bin']
end

# Previous customizations

default['mysql']['tunable']['default-storage-engine']               =   'innodb'

default['mysql']['tunable']['character_set_server']                 =   'utf8mb4'
default['mysql']['tunable']['collation_server']                     =   'utf8mb4_unicode_ci'
default['mysql']['tunable']['init_connect']                         =   'SET NAMES utf8mb4'

default['mysql']['tunable']['interactive_timeout']                  =   180

default['mysql']['tunable']['innodb_log_files_in_group']            =   2

#Because of file_per_table = true. See http://mysqldump.azundris.com/archives/78-Configuring-InnoDB-An-InnoDB-tutorial.html
default['mysql']['tunable']['innodb_autoextend_increment']          =   8

#Based on 1024mb system memory
default['mysql']['tunable']['key_buffer_size']                      =   "32M"