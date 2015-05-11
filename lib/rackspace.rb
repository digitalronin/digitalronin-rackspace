require 'fog'
require 'yaml'

module Rackspace
  # Delay between checks, when waiting for the Rackspace API
  SLEEP_DELAY = 20
  # Maximum iterations before we give up waiting for the Rackspace API
  MAX_ITERATIONS_ON_CREATE = 20

  # Cloud servers
  DEFAULT_SIZE       = 1
  DEFAULT_IMAGE_NAME = 'Ubuntu 14.04 LTS (Trusty Tahr) (PVHVM)'
  DEFAULT_FLAVOUR    = 'general1'

  # Block storage volumes
  SATA      = 'SATA'
  SSD       = 'SSD'
  MIN_SIZE  = 75
  MAX_SIZE  = 1024
  AVAILABLE = 'available'

  DEFAULT_REGION = :ord
end

libdir = File.join(File.dirname(__FILE__), 'rackspace')

require File.join(libdir, 'logger.rb')
require File.join(libdir, 'base.rb')
require File.join(libdir, 'api.rb')
require File.join(libdir, 'server_api.rb')
require File.join(libdir, 'storage_api.rb')
require File.join(libdir, 'vm.rb')
require File.join(libdir, 'volume.rb')

