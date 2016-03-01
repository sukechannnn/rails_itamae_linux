execute "ndenv install #{node[:nodejs_version]}" do
  not_if "ndenv versions | grep #{node[:nodejs_version]}"
end

execute "ndenv global #{node[:nodejs_version]}" do
  not_if "ndenv versions | grep #{node[:nodejs_version]}"
end
