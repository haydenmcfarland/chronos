# frozen_string_literal: true

require 'net/https'
require 'uri'
require 'json'

module Chronos
  module Redmine
    module Request
      module_function

      def request(method, resource, payload = {})
        base_url = Chronos::Configuration.redmine_api_base_url
        api_token = Chronos::Configuration.redmine_api_access_token

        url = "https://#{base_url}/#{resource}.json"
        uri = URI.parse(url)
        req = Object.const_get("Net::HTTP::#{method}").new(uri.request_uri)

        req['Content-Type'] = 'application/json'
        req['X-Redmine-API-Key'] = api_token
        req.body = payload.to_json

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        response = http.request(req)
        response
      end

      def post(resource, payload = {})
        request('Post', resource, payload)
      end

      def get(resource, payload = {})
        request('Get', resource, payload)
      end

      def get_resource(resource, payload)
        resp = get(resource, payload)
        resources = JSON.parse(resp.body)
        return resources[resource] if
          resources['total_count'] < resources['limit']

        batch_start = resources['offset'] + 1
        batch_end = resources['total_count'] / resources['limit']
        get_batched(resource, payload, batch_start, batch_end)
          .flatten
      end

      def get_batched(resource, payload, batch_start, batch_end)
        (batch_start..batch_end).map do |offset|
          resp = get(resource, payload.merge(offset: offset))
          resources = JSON.parse(resp.body)
          resources[resource]
        end
      end
    end
  end
end
