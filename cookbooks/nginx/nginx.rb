package 'nginx'

service 'nginx' do
  action [:enable, :start]
  subscribes :restart, 'template[/etc/nginx/conf.d/nginx.conf]'
end

template '/etc/nginx/conf.d/nginx.conf' do
  source './templates/etc/nginx/conf.d/nginx.conf.erb'
  notifies :restart, 'service[nginx]'
end
