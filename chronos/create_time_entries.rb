# frozen_string_literal: true

module Chronos
  module CreateTimeEntries
    module_function

    def resolve_issue(merge_request)
      (merge_request.source_branch[Constants::ISSUE_REGEX, 1] ||
        merge_request.title[Constants::ISSUE_REGEX, 1]).to_i
    end

    # responsible for determining chronos behavior from mr description
    def resolve_chronos_command(description)
      description[Constants::CHRONOS_REGEX, 1].to_i
    end

    def my_issue_times(from, to)
      Redmine::TimeEntries.call(from, to).each_with_object({}) do |r, h|
        issue = r['issue']
        next unless issue

        id = issue['id'].to_i
        time = DateTime.parse(r['created_on'])
        h[id] ||= time
        h[id] = time if h[id] < time
      end.compact
    end

    def my_chronos_merge_requests(dt_start, dt_end)
      Gitlab::MergeRequests.call(dt_start, dt_end).map do |merge_request|
        issue_id = resolve_issue(merge_request)
        next if issue_id.zero?

        hours = resolve_chronos_command(merge_request.description)
        next if hours.zero?

        {
          branch_name: merge_request.source_branch,
          title: merge_request.title,
          issue_id: issue_id,
          hours: hours,
          created_at: DateTime.parse(merge_request.created_at),
          updated_at: DateTime.parse(merge_request.updated_at)
        }
      end.compact
    end

    def call
      # get the current week window
      now = DateTime.parse(Date.today.to_s)
      dt_start = (now - now.wday)
      dt_end = dt_start + Constants::WEEK_OFFSET

      # get open issue ids
      my_issue_ids = Redmine::Issues.my_issue_ids
      my_issue_times_result = my_issue_times(dt_start, dt_end)

      # set default time for issues
      my_issue_ids.each { |id| my_issue_times_result[id.to_i] ||= dt_start }
      my_chronos_merge_requests(dt_start, dt_end).each do |merge_request|
        id = merge_request[:issue_id]
        time = my_issue_times_result[id]
        next unless time

        hours = merge_request[:hours]
        if merge_request[:created_at] > time ||
           merge_request[:updated_at] > time
          puts Constants::CREATE_MESSAGE % merge_request[:title]
          puts Redmine::CreateTimeEntries.call(id, hours).body
        else
          puts Constants::EXISTS_MESSAGE % id
        end
      end
    end
  end
end
