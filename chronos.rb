# frozen_string_literal: true

require 'bundler'
Bundler.require

require 'json'
# require gem ruby files
Dir[File.dirname(__FILE__) + '/**/*.rb']
  .sort.reject { |file| file.include?('chronos.rb') }
  .each { |file| require file }

Chronos::CreateTimeEntries.call
