require 'net/http'
require 'json'

url = 'https://repology.org/api/v1/projects/?inrepo=homebrew&outdated=1'
uri = URI(url)
response = Net::HTTP.get(uri)
parsed = JSON.parse(response)

File.write("repology-JSON/unformatted/latest.json", parsed)