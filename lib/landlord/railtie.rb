# frozen_string_literal: true

module Landlord
  class Railtie < ::Rails::Railtie
    initializer "landlord.insert_middleware" do |app|
      app.config.middleware.insert_before ActionDispatch::Cookies, Landlord::Middleware
    end
  end
end
