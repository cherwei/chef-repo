tokyo_lua Mash.new unless attribute?("tokyo_lua")
tokyo_lua[:url] = "http://www.lua.org/ftp/lua-5.1.4.tar.gz"

# needed to place in recipe when doing a make #{platform}
case platform
when "redhat","centos","fedora","suse","debian","ubuntu"
  tokyo_lua[:platform] = 'linux'
else
  tokyo_lua[:platform] = 'macosx'
end