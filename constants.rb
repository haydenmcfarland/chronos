# frozen_string_literal: true

module Chronos
  module Constants
    SERVICES = %w[REDMINE GITLAB].freeze
    CONFIGS = %w[BASE_URL ACCESS_TOKEN].freeze
    ISSUE_REGEX = /(\d+)/.freeze
    CHRONOS_REGEX = /.*CHRONOS\s+(\d+).*/.freeze
    WEEK_OFFSET = 6 + 23.9999 / 24
    CREATE_MESSAGE = 'Creating Time Entry for MR: %s'
    EXISTS_MESSAGE = 'Already Have Time Entry for MR: %s'
    DATE_FORMAT = '%Y-%m-%d'
    USER_ID = 'me'
    RESOURCE_LIMIT = 5
    DEFAULT_COMMENTS = 'Generated with Chronos'
    RESOURCE_ISSUES = 'time_entries'
  end
end
