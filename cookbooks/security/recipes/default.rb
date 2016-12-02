#
# Cookbook Name:: security
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

file "/etc/chef/validation.pem" do
	action :delete
end
