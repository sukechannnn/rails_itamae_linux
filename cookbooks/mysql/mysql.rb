case node[:platform]
when %r(redhat|fedora)
  execute 'yum -y remove mysql*' do
    not_if 'mysql --version | grep 5.6'
  end

  package 'http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm' do
    not_if 'rpm -q mysql-community-release-el6-5'
  end
when %r(debian|ubuntu)
  # execute 'sudo apt-get remove --purge mysql-server* mysql-common; sudo apt-get autoremove --purge; sudo rm -r /etc/mysql; sudo rm -r /var/lib/mysql' do
  #   not_if 'mysql --version | grep 5.6'
  # end

  execute 'export DEBIAN_FRONTEND=noninteractive; echo mysql-apt-config mysql-apt-config/enable-repo select mysql-5.6-dmr | sudo debconf-set-selections;'
  # execute 'wget http://dev.mysql.com/get/mysql-apt-config_0.3.3-2ubuntu14.04_all.deb'
  # execute 'wget -O mysql-apt-config.deb https://dev.mysql.com/get/mysql-apt-config_0.3.7-1debian8_all.deb'
  # execute 'dpkg -i --force-confdef --force-confold mysql-apt-config_0.3.3-2ubuntu14.04_all.deb'
  # execute 'dpkg -i --force-confdef --force-confold mysql-apt-config_0.3.3-2ubuntu14.04_all.deb'
  execute 'sudo dpkg -i mysql-apt-config.deb'
  # package 'mysql-apt-config_0.3.3-2ubuntu14.04_all.deb'
  execute "sudo apt-get update"
end

case node[:platform]
when %r(redhat|fedora)
  %w( mysql-server mysql-devel ).each do |pkg|
    package pkg
  end
when %r(debian|ubuntu)
  package 'mysql-server'
end

case node[:platform]
when %r(redhat|fedora)
  service 'mysqld' do
    action [:enable, :start]
  end
end

execute "mysql -u root -e \"SET PASSWORD=PASSWORD('#{node[:mysql][:password]}');\""
execute "mysql -uroot -p#{node[:mysql][:password]} -e \"DELETE FROM mysql.user WHERE User='';\""
execute "mysql -uroot -p#{node[:mysql][:password]} -e \"DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');\""
execute "mysql -uroot -p#{node[:mysql][:password]} -e \"DROP DATABASE test;\"; echo"
execute "mysql -uroot -p#{node[:mysql][:password]} -e \"DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'\""
