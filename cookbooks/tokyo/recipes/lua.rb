url = node[:tokyo_lua][:url]
tarball = url.split('/').last
name = tarball.split('.tar.gz').first

bash "install_lua" do
user "root"
  cwd "/tmp"
  code <<-EOH 
  wget #{url}
  tar -xvf #{tarball}
  cd #{name}
  ./configure
  make #{node[:tokyo_lua][:platform]}
  make install
  EOH
  not_if do File.exists?("/usr/local/share/tokyolua") end
end
