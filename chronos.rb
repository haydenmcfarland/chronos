# frozen_string_literal: true

require 'bundler'
Bundler.require

require 'json'
# require gem ruby files
Dir[File.dirname(__FILE__) + '/**/*.rb'].sort.each { |file| require file }

Chronos::Configuration.load_credentials

ISSUE_REGEX = /.*(\d+).*/
CHRONOS_REGEX = /.*CHRONOS.*(\d+).*/
DEFAULT_TIME = Time.parse('2020-02-24')

time_start = '2020-03-02'
time_end = '2020-03-10'

my_issue_ids = Chronos::Redmine::Issues.my_issue_ids
my_issue_times = Chronos::Redmine::TimeEntries.my_issue_times(
  time_start,
  time_end
)

my_issue_ids.each do |id|
  my_issue_times[id.to_i] ||= DEFAULT_TIME
end

Gitlab.endpoint = Chronos::Configuration.gitlab_api_base_url
Gitlab.private_token = Chronos::Configuration.gitlab_api_access_token

chronos_merge_requests = Gitlab.user_merge_requests(
  {
    created_before: time_end,
    created_after: time_start,
    updated_before: time_end,
    updated_after: time_start,
  }
).map do |mr|
  branch_name = mr.source_branch
  title = mr.title
  issue_id = (branch_name[ISSUE_REGEX] || title[ISSUE_REGEX]).to_i
  next if issue_id.zero?

  hours = mr.description[CHRONOS_REGEX, 1].to_i
  next if hours.zero?

  {
    branch_name: branch_name,
    title: title,
    issue_id: issue_id,
    created_at: Time.parse(mr.created_at),
    updated_at: Time.parse(mr.updated_at),
    hours: hours
  }
end.compact

chronos_merge_requests.each do |mr|
  id = mr[:issue_id]
  time = my_issue_times[id]
  next unless time

  hours = mr[:hours]
  if mr[:created_at] > time
    puts "Creating Time Entry for MR: #{mr[:title]}"
    puts Chronos::Redmine::TimeEntries.create_time_entry(id, hours).body
  else
    puts "Already Have Time Entry for this MR: #{id}"
  end
end

raise 'hell'
