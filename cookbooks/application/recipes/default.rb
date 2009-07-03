#
# Cookbook Name:: application
# Recipe:: default
#
# Copyright 2009, Engine Yard, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

directory "/data" do
  owner node[:user]
  mode 0755
end

node[:apps].each do |appconf|
  app = appconf[:name]
  env = appconf[:env]

  cap_directories = [
    "/data/#{app}",
    "/data/#{app}/shared",
    "/data/#{app}/shared/bin",
    "/data/#{app}/shared/config",
    "/data/#{app}/shared/log",
    "/data/#{app}/shared/pids",
    "/data/#{app}/shared/system",
    "/data/#{app}/releases",
    "/data/common"
  ]

  cap_directories.push(*node[:directories][app.to_sym]) if node[:directories] && node[:directories][app.to_sym]

  cap_directories.each do |dir|
    directory dir do
      owner node[:user]
      mode 0755
      recursive true
    end
  end

end if node[:apps]