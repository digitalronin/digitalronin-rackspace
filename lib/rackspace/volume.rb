module Rackspace
  class Volume < Base
    attr_reader :volume_type, :size, :name, :volume_id, :device

    def initialize(params)
      super params
      if @volume_id = params[:volume_id]
        fetch_volume_by_id
      else
        @volume_type = params.fetch(:volume_type, SATA)
        @size        = params.fetch(:size, MIN_SIZE)
        @name        = params.fetch(:name)
      end
    end

    def create
      log "Creating #{size}GB #{volume_type} block storage volume: #{name}"
      storage_api.create(
        size:         size,
        name:         name,
        volume_type:  volume_type,
      )
      self
    end

    def destroy
      log "Destroying volume #{name} in account #{account}"
      volume.destroy
      self
    end

    def volume
      @volume ||= storage_api.find_by_name(name)
    end

    private

    # Find an existing volume by its volume_id
    def fetch_volume_by_id
      vol  = storage_api.find_by_id(volume_id)
      data = vol.body.fetch("volume")
      @name        = data.fetch('display_name')
      @volume_type = data.fetch('volume_type')
      @size        = data.fetch('size')

      # Sometimes the Rackspace API takes time to update,
      # and newly-attached volumes don't report any attachments
      # yet.
      attachments = data.fetch('attachments')
      if attachments.any?
        @device = attachments.first.fetch('device')
      end
    end
  end
end
