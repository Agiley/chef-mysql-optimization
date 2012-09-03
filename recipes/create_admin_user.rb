if (node['mysql']['admin_user'] && node['mysql']['admin_user'].is_a?(Hash) && !node['mysql']['admin_user'].empty? && node['mysql']['admin_user']['username'] && node['mysql']['admin_user']['password'])
  execute_sql_file do
    template_path     '/tmp/create_admin_user.sql'
    template_source   'mysql/create_admin_user.sql.erb'
  end
else
  puts "Admin user hasn't been defined. Won't create a specific admin user. Set node['mysql']['admin_user']['username'] and node['mysql']['admin_user']['password'] to create an admin user."
end

