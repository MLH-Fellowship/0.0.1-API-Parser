require 'fileutils'
require 'net/http'
require 'json'

url = 'https://repology.org/api/v1/projects/?inrepo=homebrew&outdated=1'
directory = "data/repology"

puts "- Calling API #{url}"
uri = URI(url)
response = Net::HTTP.get(uri)

puts "- Parsing response"
data = JSON.parse(response)

puts "- Generating datetime stamp"
#Include time to the filename for uniqueness when fetching multiple times a day
date_time = Time.new.strftime("%Y-%m-%dT%H-%M-%S")

# Create directory if does not exist
FileUtils.mkdir_p directory unless Dir.exists?(directory)
# Writing parsed data to file
File.write("#{directory}/#{date_time}.txt", data)