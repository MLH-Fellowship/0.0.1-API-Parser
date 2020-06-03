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

puts "- Generating datestamp"
time = Time.new
date = time.strftime("%Y-%m-%d")

packages.each do |package|
  parsed_homebrew_package = {
    name: package["name"],
    fullname: package["fullname"],
    oldname: package["oldname"],
    versions: package["versions"]
  }
  parsed_homebrew_packages.push(parsed_homebrew_package)
end

# Writing parsed data to file
puts "- Writing data to file"
File.write("#{directory}/#{date}.txt", parsed_homebrew_packages.join("\n"))
