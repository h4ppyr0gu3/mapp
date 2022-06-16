require 'net/http'
require 'cgi'
require 'json'

artist = "Post Malone"

url_artist = CGI::escape(artist)

blase = "https://musicbrainz.org/ws/2/artist"

uri = URI(base)

params = { query: url_artist, limit: 10, offset: 0}
headers = {
  "Application": "mapp/1.0.0 ( rogersdpdr@gmail.com)",
  "Accept": "application/json",
  "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:101.0) Gecko/20100101 Firefox/101.0"
}

uri.query = URI.encode_www_form(params)

# http = Net::HTTP.new(uri.host)
#i
# res = http.get(uri.path, headers)
pp uri

res = Net::HTTP.get(uri, headers)

pp res

pp JSON.parse(res)

puts res.body if res.is_a?(Net::HTTPSuccess)

# Net::HTTP
