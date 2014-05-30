#!/usr/bin/env ruby

service_name = ARGV[0]
bus_kind = (ARGV[1] || :queue).to_sym

if service_name.nil?
  puts "please indicate 'service name'"
  exit(1)
end

$app_environment = ENV['SERVICE_ENV'] || 'development'
$stdout.sync = true

require 'bundler/setup'

require 'yaml'
require 'active_support/all'

require 'combi'
require 'combi/reactor'

$root_dir = File.expand_path('../../',  __FILE__)

%w{services config .}.each do |lib_dir|
  $: << File.join($root_dir, lib_dir)
end

Combi::Reactor.start

class ConfigProvider
  def self.for(config_name)
    YAML.load(ERB.new(File.read(File.expand_path("../../config/#{config_name}.yml",  __FILE__))).result)[$app_environment]
  end
end

config = ConfigProvider.for(bus_kind)
bus = Combi::ServiceBus.for(bus_kind, config['config_name'].to_sym => config)

require "services/#{service_name}"
service_class = Kernel.const_get("Service::#{service_name.camelize}")
service_instance = service_class.new
bus.add_service(service_instance)
bus.start!
puts "started!"

Combi::Reactor.join_thread
