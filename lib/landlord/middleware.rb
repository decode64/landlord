# frozen_string_literal: true

require 'rack/body_proxy'

module Landlord
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      Landlord.current_host = Rack::Request.new(env).hostname
      @app.call(env)
    ensure
      Landlord.clear!
    end
  end
end
