# frozen_string_literal: true

module Chronos
  module Gitlab
    module MergeRequests
      module_function

      def call(dt_start, dt_end)
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
