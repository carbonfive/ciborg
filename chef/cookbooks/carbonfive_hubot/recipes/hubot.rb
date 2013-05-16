include_recipe "carbonfive_hubot::id_rsa"

git "#{node["hubot"]["home"]}/hubot" do
  repository "https://github.com/carbonfive/hubot.git"
  reference "master"
  action :sync
end

execute "hubot dependency installation" do
  command "npm install"
  cwd "#{node["hubot"]["home"]}/hubot"
  not_if { ::File.exists?("#{node["hubot"]["home"]}/hubot/node_modules") }
  notifies :enable, "service[hubot]"
end

template "/etc/init.d/hubot" do
  source "hubot-initd.erb"
  owner "root"
  group "root"
  mode  0755
  notifies :restart, "service[hubot]"
end

service "hubot" do
  action :nothing
end
