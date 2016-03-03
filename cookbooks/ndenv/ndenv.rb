execute "/bin/bash -lc \"ndenv install #{node[:nodejs_version]}\"" do
  not_if "/bin/bash -lc \"ndenv versions | grep #{node[:nodejs_version]}\""
  user "#{node[:user]}"
end

execute "/bin/bash -lc \"ndenv global #{node[:nodejs_version]}\"" do
  not_if "/bin/bash -lc \"ndenv versions | grep #{node[:nodejs_version]}\""
  user "#{node[:user]}"
end
