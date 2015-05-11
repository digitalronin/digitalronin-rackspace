module Rackspace
  class Api
    attr_reader :logger

    def initialize(params)
      @logger = params.fetch(:logger, Rackspace::Logger.new)
    end

    private

    def wait_for(name)
      log "Waiting for #{object_type} #{name}"

      obj = nil; ready = false; iterations = 1

      while !ready do
        obj = find_by_name(name)

        if obj.nil?
          log "Waiting for #{object_type} #{name} to appear in API list..."
        else
          log "Found #{object_type} #{name}. Status: #{obj.state}, check #{iterations} of #{MAX_ITERATIONS_ON_CREATE}"

          if obj.state == ready_state
            ready = true
          end
        end

        iterations += 1

        raise "#{object_type} not ready after #{iterations} sleeps. Aborting." if iterations > MAX_ITERATIONS_ON_CREATE

        sleep(SLEEP_DELAY) unless ready
      end

      obj
    end

  end
end
