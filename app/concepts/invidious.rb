# frozen_string_literal: true

require 'net/http'
require 'json'

class Invidious
  class << self
    def api
      Rails.cache.fetch('active_api', expires_in: 12.hours) do
        get_active_api
      end
    end

    def get_active_api
      available_apis.each do |api|
        uri = URI("#{api}/api/v1/stats")
        res = Net::HTTP.get(uri)
        parsed = JSON.parse(res)
        return api if parsed['openRegistrations']
      end
    end

    def available_apis
      available_apis = []

      uri = URI('https://api.invidious.io/instances.json')
      res = Net::HTTP.get(uri)
      parsed = JSON.parse(res)
      parsed.each do |_k, v|
        available_apis << v['uri'] if v['api']
      end
      available_apis
    end
  end
end
