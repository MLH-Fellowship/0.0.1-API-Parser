require 'fileutils'
require 'net/http'
require 'json'

url = 'https://formulae.brew.sh/api/formula.json'
directory = "data/homebrew"

puts "- Calling API #{url}"
uri = URI(url)
response = Net::HTTP.get(uri)

puts "- Parsing response"
data = JSON.parse(response)

puts "- Generating datestamp"
time = Time.new
date = time.strftime("%Y-%m-%d")

# Create directory if does not exist
FileUtils.mkdir_p directory unless Dir.exists?(directory)
# Writing parsed data to file
File.write("#{directory}/#{date}.txt", data)

