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
  # debian & ubuntu では、mysqlを入れる際に対話モードになってしまってうまくインストール出来ない
  # execute 'export DEBIAN_FRONTEND=noninteractive;\
  # echo mysql-apt-config mysql-apt-config/enable-repo select mysql-5.6 | sudo debconf-set-selections;'
  # # execute 'wget http://dev.mysql.com/get/mysql-apt-config_0.3.3-2ubuntu14.04_all.deb'
  # execute 'wget -O mysql-apt-config.deb https://dev.mysql.com/get/mysql-apt-config_0.3.7-1debian8_all.deb'
  # # execute 'dpkg -i --force-confdef --force-confold mysql-apt-config_0.3.3-2ubuntu14.04_all.deb'
  # execute 'sudo dpkg -i mysql-apt-config.deb'
  # execute "sudo apt-get update"
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
