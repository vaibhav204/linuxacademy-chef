name "webserver"
description "apache web server role"
#run_list "recipe[security]", "recipe[apache]", "recipe[localusers]"
run_list "role[base]", "recipe[apache]"
