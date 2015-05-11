module Rackspace
  class Vm < Base
    attr_reader :name, :size, :flavor_id, :image_name, :volume

    def initialize(params)
      super params
      @name              = params.fetch(:name)
      @image_name        = params.fetch(:image_name,  DEFAULT_IMAGE_NAME)
      @size              = params.fetch(:size,        DEFAULT_SIZE)
      @flavor_id         = params.fetch(:flavor_id,   "#{DEFAULT_FLAVOUR}-#{size}")
      @volume_definition = params[:volume]
    end

    def create
      log "Creating server #{name} in account #{account}"
      @server = server_api.create(
        name:        name,
        flavor_id:   flavor_id,
        image_id:    image_id,
        personality: personality
      )
      build_and_attach_volume if @volume_definition
      self
    end

    def destroy(options = {})
      log "Destroying server #{name} in account #{account}"
      server.attachments.map(&:destroy)
      volume.destroy if options[:destroy_volume]
      server.destroy
      self
    end

    def public_ip
      server.ipv4_address
    end

    def private_ip
      server.private_ip_address
    end

    def state
      server.state
    end

    def attach_volume(vol)
      server.attach_volume(vol.volume)
    end

    def volume
      @volume ||= begin
        if attachments.any?
          Rackspace::Volume.new(
            account:     account,
            region:      region,
            credentials: credentials,
            volume_id:   attachments.first.volume_id
          )
        end
      end
    end

    private

    def attachments
      server.attachments
    end

    def build_and_attach_volume
      vol = Rackspace::Volume.new(@volume_definition.merge(
          account:      account,
          region:       region,
          credentials:  credentials,
          name:         "#{name}-vol",
      )).create

      log "Attaching block storage volume #{vol.name}"
      server.attach_volume(vol.volume)
      @volume = nil # force an API query next time volume is called
    end

    def server
      @server ||= server_api.find_by_name(name)
    end

    def personality
      [{
        'path'     => '/root/.ssh/authorized_keys',
        'contents' => Base64.encode64(credentials.fetch(:public_ssh_key)),
      }]
    end

    def image_id
      server_api.image_by_name(image_name).id
    end

    def find_by_name
      server_api.find_by_name(name)
    end

  end
end
