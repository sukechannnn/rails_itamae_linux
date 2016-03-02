# selinux disabled
package 'libselinux-utils'

execute 'setenforce 0' do
  not_if 'getenforce | grep Disabled'
end

template '/etc/selinux/config' do
  variables(selinux: 'disabled')
  source './selinux/config.erb'
end

# disallow root SSH access
# disallow password authentication
file '/etc/ssh/sshd_config' do
  mode '777'
end

file '/etc/ssh/sshd_config' do
  user 'root'
  action :edit
  block do |content|
    content.gsub!(/#PermitRootLogin yes/, 'PermitRootLogin no')
    content.gsub!(/#PasswordAuthentication yes/, 'PasswordAuthentication no')
  end
  mode '600'
end

package 'epel-release'

package "http://rpms.famillecollet.com/enterprise/remi-release-#{node[:platform_version][0]}.rpm" do
  not_if 'rpm -q remi-release'
end

# execute 'yum --disablerepo=epel update nss'

execute 'sudo yum --disablerepo=epel update -y --exclude=kernel* --exclude=centos*'

execute "yum groupinstall -y 'Development Tools'"

package 'db4-devel'
package 'git'
package 'curl'
package 'wget'
package 'tar'
package 'make'
package 'zlib-devel'
package 'ruby-devel'
package 'readline-devel'
package 'ncurses-devel'
package 'openssl'
package 'openssl-devel'
package 'sqlite-devel'
package 'libyaml'
package 'libyaml-devel'
package 'tcl-devel'
package 'libffi-devel'
package 'libxml2'
package 'libxml2-devel'
package 'libxslt'
package 'libxslt-devel'
package 'vim'

install anyenv
HOME_DIR = "/home/#{node[:user]}"

execute 'git clone https://github.com/riywo/anyenv ~/.anyenv' do
  not_if "test -d #{HOME_DIR}/.anyenv"
  user "#{node[:user]}"
end

directory "#{HOME_DIR}/.anyenv/plugins" do
  not_if "test -d #{HOME_DIR}/.anyenv/plugins"
  user "#{node[:user]}"
end

git "#{HOME_DIR}/.anyenv/plugins/anyenv-update" do
  repository 'https://github.com/znz/anyenv-update.git'
  user "#{node[:user]}"
end

git "#{HOME_DIR}/.anyenv/plugins/anyenv-git" do
  repository 'https://github.com/znz/anyenv-git.git'
  user "#{node[:user]}"
end

remote_file "#{HOME_DIR}/.bashrc" do
  source './files/.bashrc'
  mode '777'
  owner "#{node[:user]}"
  user "#{node[:user]}"
end

execute '/bin/bash -lc "anyenv install rbenv"' do
  not_if 'rbenv -v'
  user "#{node[:user]}"
end

execute '/bin/bash -lc "anyenv install ndenv"' do
  not_if 'ndenv -v'
  user "#{node[:user]}"
end
