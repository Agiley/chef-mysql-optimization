if (node['mysql']['perform_optimization'])
  ::Chef::Log.info("Will now perform additional MySQL optimization.")
  
  ::Chef::Recipe.send(:include, ChefMysqlOptimization::Mysql::Optimization)
  
  if (node['mysql']['optimization_based_on_system_memory'])
    optimizations     =   optimize_mysql(node['mysql']['system_type'].to_sym)

    optimizations.each do |key, value|
      node.set['mysql']['tunable'][key] = value
    end
  end
  
  # We need to drop innodb tablespace tables when deleting the ibdata/ib_logfile-files.
  # These tables will later be re-created
  # For more info, see: http://dba.stackexchange.com/questions/54608/innodb-error-table-mysql-innodb-table-stats-not-found-after-upgrade-to-mys
  if node['mysql']['version'].to_f >= 5.7
    execute_sql_file do
      template_path     '/tmp/drop_innodb_tablespace_tables.sql'
      template_source   'drop_innodb_tablespace_tables.sql.erb'
    end
  end
  
  # We also need to remove the actual .idb and .frm-files from disk for these tables
  if node['mysql']['version'].to_f >= 5.7
    node['mysql']['tunable']['innodb_tablespace_tables'].each do |table|
      paths     =   ["#{node['mysql']['data_dir']}/mysql/#{table}.ibd", "#{node['mysql']['data_dir']}/mysql/#{table}.frm"]
      
      paths.each do |path|
        file path do
          action :delete
          only_if { ::File.exists?(path) }
        end
      end
    end if node['mysql']['tunable']['innodb_tablespace_tables'] && node['mysql']['tunable']['innodb_tablespace_tables'].any?
  end

  # Remove ibdata, log files etc.
  bash "remove_current_data_file_and_log_files" do
    code <<-EOH
      for i in `find #{node['mysql']['data_dir']} -name 'ibdata*'`; do rm -rf $i; done;
      for i in `find #{node['mysql']['data_dir']} -name 'ib_logfile*'`; do rm -rf $i; done;
      for i in `find #{node['mysql']['data_dir']} -name 'ib_buffer_pool'`; do rm -rf $i; done;
      for i in `find #{node['mysql']['data_dir']} -name 'ibtmp1'`; do rm -rf $i; done;
    EOH
  end

  #We need to stop MySQL and then remove its datafile and logfiles before changing the innodb_log_file_size-setting. Otherwise MySQL won't start again. 
  execute "service #{node[:mysql][:service_identifier]} stop"
  
  #Due to template "#{node['mysql']['conf_dir']}/my.cnf" already being defined with notifies :restart, :immediately we have to use a custom template path
  #to not trigger the :restart-action since that will fail due to Upstart not being able to restart a service that has not already been started.
  template "#{node['mysql']['conf_dir']}/my-custom.cnf" do
    source "my.cnf.erb"
    owner "root"
    group "root"
    mode "0755"
  end
  
  bash "replace_previous_my_cnf" do
    config_file     =   "#{node['mysql']['conf_dir']}/my.cnf"
    replacement     =   "#{node['mysql']['conf_dir']}/my-custom.cnf"
    
    code <<-EOH
      if test -e #{config_file}; then mv #{config_file} #{config_file}.bak; fi;
      if test -e #{replacement}; then mv #{replacement} #{config_file}; fi;
    EOH
  end
  
  execute "service #{node[:mysql][:service_identifier]} start"
  
  if node['mysql']['version'].to_f >= 5.7
    execute_sql_file do
      template_path     '/tmp/create_innodb_tablespace_tables.sql'
      template_source   'create_innodb_tablespace_tables.sql'
    end
  end
  
  execute "service #{node[:mysql][:service_identifier]} restart"
  
else
  ::Chef::Log.info("No additional mysql performance optimization will be performed since node['mysql']['perform_optimization'] is false.")
end
