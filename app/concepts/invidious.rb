require 'net/http'
require 'json'

class Invidious 
  def self.api
    Rails.cache.fetch("active_api", expires_in: 12.hours) do
      get_active_api
    end
  end

  def self.get_active_api
    available_apis.each do |api|
      uri = URI("#{api}/api/v1/stats")
      res = Net::HTTP.get(uri)
      parsed = JSON.parse(res)
      if parsed["openRegistrations"]
        return api
      end
    end
  end

  def self.available_apis
    available_apis = []

    uri = URI("https://api.invidious.io/instances.json")
    res = Net::HTTP.get(uri)
    parsed = JSON.parse(res)
    parsed.each do |k, v|
      if v["api"]
        available_apis << v["uri"]
      end
    end
    return available_apis
  end
end
