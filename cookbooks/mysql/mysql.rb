execute 'yum -y remove mysql*' do
  not_if 'mysql --version | grep 5.6'
end

package 'http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm' do
  not_if 'rpm -q mysql-community-release-el6-5'
end

%w( mysql-community-server mysql-community-client mysql-community-devel ).each do |pkg|
  package pkg do
    not_if 'mysql --version | grep 5.6'
  end
end

service 'mysqld' do
  action [:enable, :start]
end

execute "mysql -u root -e \"SET PASSWORD=PASSWORD('#{node[:mysql][:password]}');\""
execute "mysql -uroot -p#{node[:mysql][:password]} -e \"DELETE FROM mysql.user WHERE User='';\""
execute "mysql -uroot -p#{node[:mysql][:password]} -e \"DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');\""
execute "mysql -uroot -p#{node[:mysql][:password]} -e \"DROP DATABASE test;\"; echo"
execute "mysql -uroot -p#{node[:mysql][:password]} -e \"DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'\""
