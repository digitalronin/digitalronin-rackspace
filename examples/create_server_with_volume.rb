#!/usr/bin/env ruby

require 'bundler/setup'
require './lib/rackspace'
require 'pry-byebug'

vm = Rackspace::Vm.new(
  account:  'myaccount',
  name:     'testserver',
  volume:   { size: 75 }
).create

puts "Public IP:      #{vm.public_ip}"
puts "Private IP:     #{vm.private_ip}"
puts "State:          #{vm.state}"
puts "Region:         #{vm.region}"
puts "Volume:         #{vm.volume.name}"
puts "Volume size:    #{vm.volume.size}"
puts "Volume device:  #{vm.volume.device}" # May report as nil if the Rackspace API hasn't caught up yet.

