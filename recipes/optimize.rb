if (node['mysql']['perform_optimization'])
  ::Chef::Recipe.send(:include, Mysql::Optimization)
  ::Chef::Log.info("Will now perform additional MySQL optimization.")
  
  optimizations     =   optimize_mysql(node['mysql']['system_type'].to_sym)
  
  optimizations.each do |key, value|
    node.set['mysql']['tunable'][key] = value
  end
  
  #We need to stop MySQL and then backup its datafile and logfiles before changing the innodb_log_file_size-setting. Otherwise MySQL won't start again.
  bash 'force_mysql_stop' do
    code "echo 'Forced stop of MySQL in order to backup data and log files.'"
    notifies :stop, resources(:service => "mysql"), :immediately
  end
  
  bash "remove_current_data_file_and_log_files" do
    code <<-EOH
      sleep 30;
      for i in `find #{node['mysql']['data_dir']} -name 'ibdata*'`; do rm -rf $i; done;
      for i in `find #{node['mysql']['data_dir']} -name 'ib_logfile*'`; do rm -rf $i; done;
    EOH
  end
  
  #Due to template "#{node['mysql']['conf_dir']}/my.cnf" already being defined with notifies :restart, :immediately we have to use a custom template path
  #to not trigger the :restart-action since that will fail due to Upstart not being able to restart a service that has not already been started.
  template "#{node['mysql']['conf_dir']}/my-custom.cnf" do
    source "my.cnf.erb"
    owner "root" unless platform? 'windows'
    group node['mysql']['root_group'] unless platform? 'windows'
    mode "0644"
  end
  
  bash "replace_previous_my_cnf" do
    config_file     =   "#{node['mysql']['conf_dir']}/my.cnf"
    replacement     =   "#{node['mysql']['conf_dir']}/my-custom.cnf"
    
    code <<-EOH
      if test -e #{config_file}; then mv #{config_file} #{config_file}.bak; fi;
      if test -e #{replacement}; then mv #{replacement} #{config_file}; fi;
    EOH
  end
  
  #execute "service mysql start"
  
  bash 'force_mysql_start' do
    code "echo 'Forced start of MySQL in order to pick up new config changes.'"
    notifies :start, resources(:service => "mysql"), :delayed
  end
  
else
  ::Chef::Log.info("No additional mysql performance optimization will be performed since node['mysql']['perform_optimization'] is false.")
end