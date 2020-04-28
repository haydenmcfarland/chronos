# frozen_string_literal: true

module Chronos
  module Constants
    CONFIGS = %w[BASE_URL ACCESS_TOKEN].freeze
    CHRONOS_REGEX = /.*CHRONOS\s+(\d+).*/.freeze
    CREATE_MESSAGE = 'Creating Time Entry for MR: %s'
    DATE_FORMAT = '%Y-%m-%d'
    DEFAULT_COMMENTS = 'Generated with Chronos'
    EXISTS_MESSAGE = 'Already Have Time Entry for MR: %s'
    ISSUE_REGEX = /(\d+)/.freeze
    RESOURCE_ISSUES = 'time_entries'
    RESOURCE_LIMIT = 5
    SERVICES = %w[REDMINE GITLAB].freeze
    USER_ID = 'me'
    WEEK_OFFSET = 6.9999
  end
end
