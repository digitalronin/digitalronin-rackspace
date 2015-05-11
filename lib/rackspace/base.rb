module Rackspace
  class Base
    attr_reader :account, :region, :credentials, :logger

    DEFAULT_CREDENTIALS = 'rackspace_credentials.yml'

    def initialize(params)
      @logger            = params.fetch(:logger, Rackspace::Logger.new)
      @account           = params.fetch(:account)
      @region            = params.fetch(:region, DEFAULT_REGION)
      @credentials       = params.fetch(:credentials) {
        credentials_file = params.fetch(:credentials_file, DEFAULT_CREDENTIALS)
        YAML.load(File.read(credentials_file))
      }
    end

    def log(msg)
      logger.log(msg)
    end

    def server_api
      @server_api ||= ServerApi.new(rackspace_credentials)
    end

    def storage_api
      @storage_api ||= StorageApi.new(rackspace_credentials)
    end

    private

    def accounts
      credentials.fetch(:accounts) { raise("No :accounts section found in credentials") }
    end

    def rackspace_credentials
      {
        rackspace_username: account,
        rackspace_api_key:  accounts.fetch(account) { raise("No API key found for account: #{account}") },
        rackspace_region:   region,
      }
    end

  end
end
