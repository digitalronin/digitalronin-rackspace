module Rackspace
  class ServerApi < Api
    attr_reader :api

    def initialize(rackspace_credentials)
      super rackspace_credentials
      @api ||= Fog::Compute.new(
        rackspace_credentials.merge(
          version:   :v2,
          provider:  'Rackspace',
        )
      )
    end

    def find_by_name(name)
      servers.detect {|i| i.name == name && i.state != 'DELETED'}
    end

    def create(params)
      servers.create(params)
      wait_for params.fetch(:name)
    end

    def image_by_name(img_name)
      img = api.images.detect {|i| i.name == img_name}
      raise "No such server image #{img_name}" if img.nil?
      img
    end

    def servers
      api.servers
    end

    private

    def object_type
      'server'
    end

    def ready_state
      'ACTIVE'
    end

  end
end
