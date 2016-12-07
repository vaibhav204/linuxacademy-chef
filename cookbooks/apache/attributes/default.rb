default["apache"]["sites"]["vaibhav2046"] = { "site_title" => "Vaibhav2046 website coming soon", "port" => 80, "domain" => "vaibhav2046.mylabserver.com" }
default["apache"]["sites"]["vaibhav2046b"] = { "site_title" => "Vaibhav2046b website coming soon", "port" => 80, "domain" => "vaibhav2046b.mylabserver.com" }

default["apache"]["sites"]["vaibhav2043"] = { "site_title" => "Vaibhav2043 website coming soon", "port" => 80, "domain" => "vaibhav2043.mylabserver.com" }

default["author"]["name"] = "vaibhav"

case node["platform"]
when "centos"
	default["apache"]["package"] = "httpd"
when "ubuntu"
	default["apache"]["package"] = "apache2"
end
