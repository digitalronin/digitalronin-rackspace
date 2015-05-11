module Rackspace
  class StorageApi < Api
    attr_reader :api

    def initialize(rackspace_credentials)
      super rackspace_credentials
      @api ||= Fog::Rackspace::BlockStorage.new(rackspace_credentials)
    end

    def find_by_name(name)
      api.volumes.detect { |v| v.display_name == name }
    end

    def find_by_id(volume_id)
      api.get_volume volume_id
    end

    def create(params)
      name = params.fetch(:name)

      api.volumes.create(
        size:          params.fetch(:size),
        display_name:  name,
        volume_type:   params.fetch(:volume_type),
      )
      wait_for(name)
    end

    def destroy(name)
      find_by_name(name).destroy
    end

    private

    def object_type
      'volume'
    end

    def ready_state
      AVAILABLE
    end

  end
end
