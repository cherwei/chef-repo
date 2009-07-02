url = node[:tokyo_cabinet][:url]
tarball = url.split('/').last
name = tarball.split('.tar.gz').first

bash "install_cabinet" do
user "root"
  cwd "/tmp"
  code <<-EOH 
  wget #{url}
  tar -xvf #{tarball}
  cd #{name}
  ./configure --with-lua --enable-lua
  make
  make install
  EOH
end
