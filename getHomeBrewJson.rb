require 'fileutils'
require 'net/http'
require 'json'

url = 'https://formulae.brew.sh/api/formula.json'
directory = "data/homebrew"
parsed_homebrew_packages = []

puts "- Calling API #{url}"
uri = URI(url)
response = Net::HTTP.get(uri)

puts "- Parsing response"
packages = JSON.parse(response)

# Create directory if does not exist
FileUtils.mkdir_p directory unless Dir.exists?(directory)

puts "- Generating datetime stamp"
#Include time to the filename for uniqueness when fetching multiple times a day
date_time = Time.new.strftime("%Y-%m-%dT%H:%M:%S")

packages.each do |package|
  parsed_homebrew_package = {}
  parsed_homebrew_package['name'] = package["name"]
  parsed_homebrew_package['fullname'] = package["fullname"],
  parsed_homebrew_package['oldname'] = package["oldname"],
  parsed_homebrew_package['versions'] = package["versions"]
  parsed_homebrew_packages.push(parsed_homebrew_package)
end

# Writing parsed data to file
puts "- Writing data to file"
File.write("#{directory}/#{date_time}.txt", parsed_homebrew_packages.join("\n"))
