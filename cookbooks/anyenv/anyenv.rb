# install anyenv
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
  # sudo で実行する場合は下記要らない
  # mode '755'
  # owner "#{node[:user]}"
  user "#{node[:user]}"
end

execute '/bin/bash -lc "anyenv install rbenv"' do
  not_if "test -d #{HOME_DIR}/.anyenv/envs/rbenv"
  user "#{node[:user]}"
end

execute '/bin/bash -lc "anyenv install ndenv"' do
  not_if "test -d #{HOME_DIR}/.anyenv/envs/ndenv"
  user "#{node[:user]}"
end
