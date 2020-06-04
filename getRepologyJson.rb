require 'fileutils'
require 'net/http'
require 'json'

url = 'https://repology.org/api/v1/projects/?inrepo=homebrew&outdated=1'
directory = "data/repology"
outdated_repology_packages = []

puts "- Calling API #{url}"
uri = URI(url)
response = Net::HTTP.get(uri)

puts "- Parsing response"
packages = JSON.parse(response)
puts packages.size
puts packages.at(199)
abort

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

puts "- Generating datestamp"
time = Time.new
date = time.strftime("%Y-%m-%d")

# Writing parsed data to file
puts "- Writing data to file"
File.write("#{directory}/#{date}.txt", outdated_repology_packages.join("\n"))