#!/usr/bin/env ruby

require 'bundler/setup'
require './lib/rackspace'
require 'pry-byebug'

Rackspace::Vm.new(account: 'myaccount', name: 'testserver').destroy(destroy_volume: true)
