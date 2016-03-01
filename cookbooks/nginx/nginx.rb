# nginx install and setting
package 'http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm' do
  not_if 'rpm -q nginx-release-centos-6-0.el6.ngx.noarch'
end

package 'nginx'

service 'nginx' do
  action [:enable, :start]
end

template '/etc/nginx/nginx.conf' do
  source './templates/nginx.conf.erb'
  notifies :restart, 'service[nginx]'
end
