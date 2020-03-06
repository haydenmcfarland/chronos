# frozen_string_literal: true

module Chronos
  module Configuration
    module_function

    def load_credentials
      Chronos::Constants::SERVICES.each do |service|
        Chronos::Constants::CONFIGS.each do |config|
          assign_service_config(service, config)
        end
      end
    end

    def assign_service_config(service, config)
      key = "#{service}_API_#{config}"
      accessor = key.downcase
      singleton_class.class_eval { attr_accessor accessor }
      send("#{accessor}=", ENV[key])
    end
  end
end
