#!/usr/bin/env ruby

require 'bundler/setup'
require './lib/rackspace'
require 'pry-byebug'

Rackspace::Volume.new(account: 'myaccount', name: 'myvol').destroy
