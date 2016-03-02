node[:rbenv][:versions].each do |version|
  execute "/bin/bash -lc \"rbenv install #{version}\"" do
    not_if "rbenv versions | grep #{version}"
    user "#{node[:user]}"
  end
end

execute "rbenv global #{node[:rbenv][:global]}" do
  not_if "rbenv versions | grep #{node[:rbenv][:global]}"
end
