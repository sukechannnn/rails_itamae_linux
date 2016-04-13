# selinux disabled
case node[:platform]
when %r(redhat|fedora)
  package 'libselinux-utils'
when %r(debian|ubuntu)
  package 'selinux-utils'
end

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
  action :edit
  block do |content|
    case node[:platform]
    when %r(redhat|fedora)
      content.gsub!(/#PermitRootLogin yes/, 'PermitRootLogin no')
    when %r(debian|ubuntu)
      content.gsub!(/PermitRootLogin without-password/, 'PermitRootLogin no')
    end
    content.gsub!(/#PasswordAuthentication yes/, 'PasswordAuthentication no')
  end
  mode '600'
end

package 'git'
package 'curl'
package 'wget'
package 'tar'
package 'make'
package 'openssl'
package 'libxml2'
package 'vim'

# install kernel-devel
execute 'wget "ftp://mirror.switch.ch/pool/4/mirror/scientificlinux/6.3/x86_64/updates/security/kernel-devel-2.6.32-431.el6.x86_64.rpm"; \
         sudo rpm -ivh kernel-devel-2.6.32-431.el6.x86_64.rpm' do
  not_if 'rpm -qa | grep kernel-devel'
end

# なぜかこれ入れると死ぬ
# package 'epel-release'
case node[:platform]
when %r(redhat|fedora)
  package "http://rpms.famillecollet.com/enterprise/remi-release-#{node[:platform_version][0]}.rpm" do
    not_if 'rpm -q remi-release'
  end
  execute "yum groupinstall -y 'Development Tools'"
  execute 'sudo yum --disablerepo=epel update -y --exclude=kernel* --exclude=centos*'
when %r(debian|ubuntu)
  execute "sudo apt-get update"
end

case node[:platform]
when %r(debian|ubuntu)
  package 'autoconf'
  package 'bison'
  package 'build-essential'
  package 'libssl-dev'
  package 'libyaml-dev'
  package 'libreadline6'
  package 'libreadline6-dev'
  package 'zlib1g-dev'
  package 'libncurses5-dev'
  package 'libffi-dev'
  package 'ruby-dev'
  package 'libsqlite3-dev'
  package 'tcl-dev'
when %r(redhat|fedora|amazon)
  package 'db4-devel'
  package 'zlib-devel'
  package 'readline-devel'
  package 'openssl-devel'
  package 'libyaml'
  package 'libyaml-devel'
  package 'libffi-devel'
  package 'libxml2-devel'
  package 'libxslt'
  package 'libxslt-devel'
  package 'ncurses-devel'
  package 'ruby-devel'
  package 'sqlite-devel'
  package 'tcl-devel'
end
