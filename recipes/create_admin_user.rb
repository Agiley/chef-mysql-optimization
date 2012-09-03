if (node['mysql']['admin_user'] && node['mysql']['admin_user'].is_a?(Hash) && !node['mysql']['admin_user'].empty? && node['mysql']['admin_user']['username'] && node['mysql']['admin_user']['password'])
  execute_sql_file do
    template_path     '/tmp/create_admin_user.sql'
    template_source   'create_admin_user.sql.erb'
  end
end

