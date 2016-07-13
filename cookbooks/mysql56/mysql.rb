# execute "sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'"
# execute "sudo apt-get update"

case node[:platform]
when %r(redhat|fedora)
  execute 'yum -y remove mysql*' do
    not_if 'mysql --version | grep 5.6'
  end

  package 'http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm' do
    not_if 'rpm -q mysql-community-release-el6-5'
  end
when %r(debian|ubuntu)
  # debconfを設定しないと対話モードにになってしまう
  # execute 'wget http://dev.mysql.com/get/mysql-apt-config_0.3.3-2ubuntu14.04_all.deb'
  execute 'aptitude -y install mysql-apt-config_0.3.3-2ubuntu14.04_all.deb'

  execute 'export DEBIAN_FRONTEND="noninteractive";\
  echo "mysql-server-5.6 mysql-server/root_password password root" | debconf-set-selections;\
  echo "mysql-server-5.6 mysql-server/root_password_again password root" | debconf-set-selections'
  # execute 'wget -O mysql-apt-config.deb https://dev.mysql.com/get/mysql-apt-config_0.3.7-1debian8_all.deb'

  # execute 'sudo dpkg -i mysql-apt-config.deb'
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
