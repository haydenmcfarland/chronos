# frozen_string_literal: true

module Chronos
  module Gitlab
    def load_credentials
      endpoint = "https://#{Configuration.gitlab_api_base_url}"
      ::Gitlab.endpoint = endpoint
      ::Gitlab.private_token = Configuration.gitlab_api_access_token
    end
  end
end
