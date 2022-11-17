# frozen_string_literal: true

module Landlord
  class Railtie < ::Rails::Railtie
    initializer "landlord.insert_middleware" do |app|
      app.config.middleware.insert_after ActionDispatch::RequestId, Landlord::Middleware
    end
  end
end
