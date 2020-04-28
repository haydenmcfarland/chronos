# frozen_string_literal: true

require 'gitlab'

module Chronos
  module Gitlab
    module_function

    def load_credentials
      endpoint = "https://#{Configuration.gitlab_api_base_url}"
      ::Gitlab.endpoint = endpoint
      ::Gitlab.private_token = Configuration.gitlab_api_access_token
    end
  end
end
