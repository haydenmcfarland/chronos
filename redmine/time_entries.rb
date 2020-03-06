# frozen_string_literal: true

require 'date'

module Chronos
  module Redmine
    module TimeEntries
      DEFAULT_COMMENTS = Chronos::Constants::DEFAULT_COMMENTS

      module_function

      def my_time_entries(from, to)
        time_from = DateTime.parse(from.to_s)
        time_to = DateTime.parse(to.to_s)

        payload = {
          user_id: Chronos::Constants::USER_ID,
          from: time_from.strftime(Chronos::Constants::DATE_FORMAT),
          to: time_to.strftime(Chronos::Constants::DATE_FORMAT),
          limit: Chronos::Constants::RESOURCE_LIMIT
        }

        Chronos::Redmine::Request.get_resource(
          Chronos::Constants::RESOURCE_ISSUES,
          payload
        )
      end

      def create_time_entry(issue_id, hours, comments = DEFAULT_COMMENTS)
        Chronos::Redmine::Request.post(
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
