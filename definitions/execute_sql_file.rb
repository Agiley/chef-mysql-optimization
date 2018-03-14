define :execute_sql_file, :variables => {}, :template_cookbook => "mysql-optimization", :template_source => nil do
  template params[:template_path] do
    source params[:template_source]
    cookbook params[:template_cookbook]
    variables params[:variables]
    owner "root"
    group node['mysql']['root_group']
    mode "0600"
    action :create
  end

  execute "execute_sql_script" do
    parameters  =   ""
    parameters +=   " #{node[:mysql][:binary][:arguments]}" unless node[:mysql][:binary][:arguments].empty?
    parameters +=   " -u root"
    parameters +=   " -p\"#{node[:mysql][:server_root_password]}\"" unless node[:mysql][:server_root_password].empty?
    
    command "#{node[:mysql][:binary][:path]}#{parameters} < \"#{params[:template_path]}\""
  end

  file params[:template_path] do
    action :delete
    only_if { File.exists?(params[:template_path]) }
  end
end
