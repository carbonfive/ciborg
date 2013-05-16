file "/etc/apt/sources.list.d/canonical_partner.list" do
  content "deb http://archive.canonical.com/ubuntu/ precise partner"
  notifies :run, "execute[apt-get update]", :immediately
end

execute "apt-get update" do
  action :nothing
end

template "/etc/init.d/skype" do
  source "skype-initd.erb"
  owner "root"
  group "root"
  mode  0755
  notifies :restart, "service[xvfb]"
  notifies :restart, "service[fluxbox]"
  notifies :restart, "service[skype]"
end

package "skype" do
  notifies :enable, "service[xvfb]"
  notifies :enable, "service[fluxbox]"
  notifies :enable, "service[skype]"
end

service "skype" do
  action :nothing
end
