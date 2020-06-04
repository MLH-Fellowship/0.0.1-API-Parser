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

puts "- Generating datestamp"
time = Time.new
date = time.strftime("%Y-%m-%d")


parsedResults= []
data.each do |key, value|
	parsedResults.push(key)
	value.each do |item|
		parsedResults.push(repo: item["repo"], version: item["version"])
	end
end

# Create directory if does not exist
FileUtils.mkdir_p directory unless Dir.exists?(directory)
# Writing parsed data to file
File.write("#{directory}/#{date}.txt", parsedResults)
