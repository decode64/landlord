# frozen_string_literal: true

require_relative "landlord/version"
require_relative "landlord/middleware"
require_relative "landlord/models"
require_relative "landlord/railtie" if defined?(Rails::Railtie)

module Landlord
  class Error < StandardError; end

  class Configuration
    attr_accessor :tenant_host_field, :tenant_class

    def initialize
      @tenant_host_field = :host
      @tenant_class = nil
    end
  end

  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def current_host=(host)
      Thread.current[:tenant_host] = host
    end

    def current_host
      Thread.current[:tenant_host]
    end

    def current_tenant
      Thread.current[:tenant] ||= begin
        return unless configuration.tenant_class && current_host

        configuration.tenant_class.find_by(configuration.tenant_host_field => current_host)
      end
    end

    def clear!
      Thread.current[:tenant_host] = nil
      Thread.current[:tenant] = nil
    end
  end
end
