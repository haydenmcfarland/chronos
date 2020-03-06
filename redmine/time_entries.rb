# frozen_string_literal: true

require 'date'

module Chronos
  module Redmine
    module TimeEntries
      DATE_FORMAT = '%Y-%m-%d'
      USER_ID = 'me'
      LIMIT = 5

      module_function

      def my_time_entries(from, to)
        time_from = Date.parse(from)
        time_to = Date.parse(to)

        payload = {
          user_id: USER_ID,
          from: time_from.strftime(DATE_FORMAT),
          to: time_to.strftime(DATE_FORMAT),
          limit: LIMIT
        }
        resources = 'time_entries'
        Chronos::Redmine::Request.get_resource(resources, payload)
      end

      def my_issue_times(from, to)
        my_time_entries(from, to).each_with_object({}) do |r, h|
          issue = r['issue']
          next unless issue

          # FIXME: consider time zone
          h[issue['id'].to_i] = Time.parse(r['created_on'])
        end.compact
      end

      def create_time_entry(issue_id, hours, comments = 'misc work')
        resource = 'time_entries'
        payload = {
          time_entry: {
            issue_id: issue_id,
            hours: hours,
            comments: comments
          }
        }

        Chronos::Redmine::Request.post(resource, payload)
      end
    end
  end
end
