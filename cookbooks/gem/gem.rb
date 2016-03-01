node[:gems].each do |gem|
  execute "gem install #{gem}" do
    not_if "gem list | grep #{gem}"
  end
end

execute "gem Install rails -v #{node[:rails_version]}" do
  not_if "rails -v | grep #{node[:rails_version]}"
end
