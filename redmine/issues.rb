# frozen_string_literal: true

module Chronos
  module Redmine
    module Issues
      module_function

      def my_issues
        payload = { assigned_to_id: 'me', open: true }
        resource = 'issues'
        Chronos::Redmine::Request.get_resource(resource, payload)
      end

      def my_issue_ids
        my_issues.map { |r| r['id'] }
      end
    end
  end
end
