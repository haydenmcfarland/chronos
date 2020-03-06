# frozen_string_literal: true

module Chronos
  module Gitlab
    module Request
      module_function

      def load_credentials
        endpoint = "https://#{Chronos::Configuration.gitlab_api_base_url}"
        ::Gitlab.endpoint = endpoint
        ::Gitlab.private_token = Chronos::Configuration.gitlab_api_access_token
      end

      def my_merge_requests(dt_start, dt_end)
        load_credentials
        ::Gitlab.user_merge_requests(
          {
            created_before: dt_end,
            created_after: dt_start,
            updated_before: dt_end,
            updated_after: dt_start
          }
        )
      end
    end
  end
end
