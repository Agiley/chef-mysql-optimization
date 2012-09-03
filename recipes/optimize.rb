if (node['mysql']['perform_optimization'])
  ::Chef::Recipe.send(:include, Mysql::Optimization)
  ::Chef::Log.info("Will now perform additional MySQL optimization.")
  
  optimizations = optimize_mysql(node['mysql']['system_type'].to_sym)
  
  optimizations.each do |key, value|
    node.set['mysql']['tunable'][key] = value
  end
  
  template "#{node['mysql']['conf_dir']}/my.cnf" do
    source "my.cnf.erb"
    owner "root" unless platform? 'windows'
    group node['mysql']['root_group'] unless platform? 'windows'
    mode "0644"
    notifies :restart, resources(:service => "mysql"), :immediately
    variables :skip_federated => skip_federated
  end
  
else
  ::Chef::Log.info("No additional mysql performance optimization will be performed since node['mysql']['perform_optimization'] is false.")
end