include_recipe "yk_kernel_devel::install"
include_recipe '../cookbooks/base/base.rb'
include_recipe '../cookbooks/anyenv/anyenv.rb'
include_recipe '../cookbooks/rbenv/rbenv.rb'
include_recipe '../cookbooks/ndenv/ndenv.rb'
include_recipe '../cookbooks/gem/gem.rb'
include_recipe '../cookbooks/mysql56/mysql.rb'
include_recipe '../cookbooks/nginx/nginx.rb'
include_recipe '../cookbooks/redis/redis.rb'
