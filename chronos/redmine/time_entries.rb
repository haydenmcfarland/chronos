# frozen_string_literal: true

require 'date'

module Chronos
  module Redmine
    module TimeEntries
      DEFAULT_COMMENTS = Chronos::Constants::DEFAULT_COMMENTS

      module_function

      def call(from, to)
        datetime_from = DateTime.parse(from.to_s)
        datetime_to = DateTime.parse(to.to_s)

        payload = {
          user_id: Chronos::Constants::USER_ID,
          from: datetime_from.strftime(Chronos::Constants::DATE_FORMAT),
          to: datetime_to.strftime(Chronos::Constants::DATE_FORMAT),
          limit: Chronos::Constants::RESOURCE_LIMIT
        }

        Request.get_resource(Chronos::Constants::RESOURCE_ISSUES, payload)
      end
    end
  end
end
