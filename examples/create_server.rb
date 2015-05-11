#!/usr/bin/env ruby

require 'bundler/setup'
require './lib/rackspace'
require 'pry-byebug'

vm = Rackspace::Vm.new(account: 'myaccount', name: 'testserver').create

puts "Public IP:   #{vm.public_ip}"
puts "Private IP:  #{vm.private_ip}"
puts "State:       #{vm.state}"
puts "Region:      #{vm.region}"


