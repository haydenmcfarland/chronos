# frozen_string_literal: true

module Chronos
  module CreateTimeEntries
    ISSUE_REGEX = Chronos::Constants::ISSUE_REGEX
    CHRONOS_REGEX = Chronos::Constants::CHRONOS_REGEX

    module_function

    def resolve_issue(merge_request)
      (merge_request.source_branch[ISSUE_REGEX] ||
        merge_request.title[ISSUE_REGEX]).to_i
    end

    # responsible for determining chronos behavior from mr description
    def resolve_chronos_command(description)
      result = description[CHRONOS_REGEX]
      (result || '').split[-1].to_i
    end

    def my_issue_times(from, to)
      Chronos::Redmine::TimeEntries
        .my_time_entries(from, to).each_with_object({}) do |r, h|
        issue = r['issue']
        next unless issue

        id = issue['id'].to_i
        time = DateTime.parse(r['created_on'])
        h[id] ||= time
        h[id] = time if h[id] < time
      end.compact
    end

    def my_chronos_merge_requests(dt_start, dt_end)
      Chronos::Gitlab::Request
        .my_merge_requests(dt_start, dt_end).map do |merge_request|
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
      Chronos::Configuration.load_credentials

      # get the current week window
      now = DateTime.parse(Date.today.to_s)
      dt_start = (now - now.wday)
      dt_end = dt_start + Chronos::Constants::WEEK_OFFSET

      # get open issue ids
      my_issue_ids = Chronos::Redmine::Issues.my_issue_ids
      my_issue_times = my_issue_times(
        dt_start,
        dt_end
      )

      # set default time for issues
      my_issue_ids.each do |id|
        my_issue_times[id.to_i] ||= dt_start
      end

      my_chronos_merge_requests(dt_start, dt_end).each do |merge_request|
        id = merge_request[:issue_id]
        time = my_issue_times[id]
        next unless time

        hours = merge_request[:hours]
        if merge_request[:created_at] > time ||
           merge_request[:updated_at] > time
          puts Chronos::Constants::CREATE_MESSAGE % merge_request[:title]
          puts Chronos::Redmine::TimeEntries
            .create_time_entry(id, hours).body
        else
          puts Chronos::Constants::EXISTS_MESSAGE % id
        end
      end
    end
  end
end
