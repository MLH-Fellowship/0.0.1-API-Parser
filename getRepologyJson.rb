require 'fileutils'
require 'net/http'
require 'json'

def parse_repology(lastpackage)
  url = 'https://repology.org/api/v1/projects/' + lastpackage + '?inrepo=homebrew&outdated=1'
  
  puts "- Calling API #{url}"
  uri = URI(url)
  response = Net::HTTP.get(uri)

  puts "- Parsing response"
  return JSON.parse(response)
end

directory = "data/repology"
outdated_repology_packages = []

packages = parse_repology('')
last_index = packages.size - 1
response_size = packages.size

while response_size > 1  do
  puts "- Paginating"
  last_package = packages.keys[last_index]
  response = parse_repology("#{last_package}/")
  response_size = response.size
  packages.merge!(response)
  last_index = packages.size - 1
end

packages.each do |package|
  parsed_outdated_package = {}
  parsed_outdated_package["packagename"] = package[0]

  for project in package[1] do
    result = package[1].find {|item| item["status"] == "newest" or item["status"] == "devel" }
    parsed_outdated_package["newestversion"] = result["version"]

    if project["repo"] == "homebrew"
      parsed_outdated_package["srcname"] = project["srcname"]
      parsed_outdated_package["visiblename"] = project["visiblename"]
      parsed_outdated_package["currentversion"] = project["version"]
    end
  end
  outdated_repology_packages.push(parsed_outdated_package)
end

# Create directory if does not exist
FileUtils.mkdir_p directory unless Dir.exists?(directory)

puts "- Generating datetime stamp"
#Include time to the filename for uniqueness when fetching multiple times a day
date_time = Time.new.strftime("%Y-%m-%dT%H-%M-%S")

# Writing parsed data to file
puts "- Writing data to file"
File.write("#{directory}/#{date_time}.txt", outdated_repology_packages.join("\n"))

