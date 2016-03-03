node[:gems].each do |gem|
  execute "gem install #{gem}" do
    not_if "gem list | grep #{gem}"
  end
  user "#{node[:user]}"
end

execute "/bin/bash -lc \"gem install rails -v #{node[:rails_version]}\"" do
  not_if "rails -v | grep #{node[:rails_version]}"
  user "#{node[:user]}"
end
