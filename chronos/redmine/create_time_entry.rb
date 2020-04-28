# frozen_string_literal: true

require 'date'

module Chronos
  module Redmine
    module CreateTimeEntries
      DEFAULT_COMMENTS = Chronos::Constants::DEFAULT_COMMENTS

      module_function

      def call(issue_id, hours, comments = DEFAULT_COMMENTS)
        Request.post(
          Chronos::Constants::RESOURCE_ISSUES,
          {
            time_entry: {
              issue_id: issue_id,
              hours: hours,
              comments: comments
            }
          }
        )
      end
    end
  end
end
