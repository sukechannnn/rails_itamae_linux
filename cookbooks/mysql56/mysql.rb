execute 'yum -y remove mysql*' do
  not_if 'mysql --version | grep 5.6'
end

package 'http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm' do
  not_if 'rpm -q mysql-community-release-el6-5'
end

%w( mysql-community-server mysql-community-devel ).each do |pkg|
  package pkg do
    not_if 'mysql --version | grep 5.6'
  end
end

service 'mysqld' do
  action [:enable, :start]
end
