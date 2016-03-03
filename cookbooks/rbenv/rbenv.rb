node[:rbenv][:versions].each do |version|
  execute "/bin/bash -lc \"rbenv install #{version}\"" do
    not_if "/bin/bash -lc \"rbenv versions | grep #{version}\""
    user "#{node[:user]}"
  end
end

execute "/bin/bash -lc \"rbenv global #{node[:rbenv][:global]}\"" do
  not_if "/bin/bash -lc \"rbenv global | grep #{node[:rbenv][:global]}\""
  user "#{node[:user]}"
end
