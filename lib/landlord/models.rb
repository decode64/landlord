# frozen_string_literal: true

module Landlord
  module Models
    def landlord(field)
      Landlord.configuration.tenant_class = self
      Landlord.configuration.tenant_host_field = field
    end

    def multi_tenant(field)
      field.to_s.camelize.constantize

      belongs_to field
      before_validation "set_#{field}".to_sym
      default_scope { where(field => Landlord.current_tenant) }
      validates field, presence: true

      scope "from_#{field}", lambda { |value| unscoped.where(field => value) }

      define_method("set_#{field}") do
        send("#{field}=", Landlord.current_tenant)
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  extend Landlord::Models
end
