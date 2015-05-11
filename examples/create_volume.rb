#!/usr/bin/env ruby

require 'bundler/setup'
require './lib/rackspace'
require 'pry-byebug'

volume = Rackspace::Volume.new(account: 'myaccount', name: 'myvol').create

puts "Name:  #{volume.name}"
puts "Size:  #{volume.size}"
puts "Type:  #{volume.volume_type}"


