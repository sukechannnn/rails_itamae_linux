node[:rbenv][:versions].each do |version|
  execute "rbenv install #{version}" do
    not_if "rbenv versions | grep #{version}"
  end
end

execute "rbenv global #{node[:rbenv][:global]}" do
  not_if "rbenv versions | grep #{node[:rbenv][:global]}"
end
