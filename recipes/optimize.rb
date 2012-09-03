if (node['mysql']['perform_optimization'])
  ::Chef::Recipe.send(:include, Mysql::Optimization)
  ::Chef::Log.info("Will now perform additional MySQL optimization.")
  
  optimizations     =   optimize_mysql(node['mysql']['system_type'].to_sym)
  
  optimizations.each do |key, value|
    node.set['mysql']['tunable'][key] = value
  end
  
  #We need to stop MySQL and then backup its datafile and logfiles before changing the innodb_log_file_size-setting. Otherwise MySQL won't start.
  service "mysql" do
    action :stop
  end
  
  bash "backup_current_data_and_log_files" do
    backup_folder   =   "backup"
    
    code <<-EOH
      mkdir -p #{node['mysql']['data_dir']}/#{backup_folder}
      mv #{node['mysql']['data_dir']}/ibdata1 #{node['mysql']['data_dir']}/#{backup_folder}/ibdata1
    EOH

    0.upto(node['mysql']['tunable']['innodb_log_files_in_group'] - 1) do |i|
      code "mv #{node['mysql']['data_dir']}/ib_logfile#{i} #{node['mysql']['data_dir']}/#{backup_folder}/ib_logfile#{i}"
    end
  end
  
  template "#{node['mysql']['conf_dir']}/my.cnf" do
    source "my.cnf.erb"
    owner "root" unless platform? 'windows'
    group node['mysql']['root_group'] unless platform? 'windows'
    mode "0644"
    notifies :start, resources(:service => "mysql"), :immediately
  end
  
else
  ::Chef::Log.info("No additional mysql performance optimization will be performed since node['mysql']['perform_optimization'] is false.")
end