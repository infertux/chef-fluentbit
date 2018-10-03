#
# Cookbook:: fluentbit
# Recipe:: default
#

include_recipe 'fluentbit::install'
include_recipe 'fluentbit::forward'
include_recipe 'fluentbit::mail'
