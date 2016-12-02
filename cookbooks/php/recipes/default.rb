#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package "php" do 
	action :install
end

cookbook_file "/etc/php.ini" do
	source "php.ini"
	mode "0644"
end
