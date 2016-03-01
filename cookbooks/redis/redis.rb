package 'redis' do
  options '--enablerepo=epel'
end

service 'redis' do
  action [:enable, :start]
end
