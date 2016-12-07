name "base"
description "Contains recipes which should be run on all nodes"
#run_list "recipe[security]", "recipe[localusers]"
run_list "recipe[chef-client::delete_validation]", "recipe[chef-client::cron]", "recipe[chef-client]", "recipe[localusers]"
