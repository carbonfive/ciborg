template "/etc/init.d/fluxbox" do
  source "fluxbox-initd.erb"
  owner "root"
  group "root"
  mode  0755
  notifies :restart, "service[xvfb]"
  notifies :restart, "service[fluxbox]"
end

package "fluxbox" do
  notifies :enable, "service[xvfb]"
  notifies :enable, "service[fluxbox]"
end

service "fluxbox" do
  action :nothing
end
