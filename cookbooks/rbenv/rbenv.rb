RBENV_ROOT = '/usr/local/rbenv'
RBENV_SCRIPT = '/etc/profile.d/rbenv.sh'

git RBENV_ROOT do
  repository 'git://github.com/sstephenson/rbenv.git'
end

directory RBENV_ROOT + 'plugins'

git "#{RBENV_ROOT}/plugins/ruby-build" do
  repository 'git://github.com/sstephenson/ruby-build.git'
end

remote_file RBENV_SCRIPT do
  source 'files/rbenv.sh'
  owner 'root'
  mode '644'
  user 'root'
end

execute "rbenv install #{node[:ruby_version]}" do
  not_if "rbenv versions | grep #{node[:ruby_version]}"
end

execute "rbenv global #{node[:ruby_version]}" do
  not_if "rbenv versions | grep #{node[:ruby_version]}"
end
