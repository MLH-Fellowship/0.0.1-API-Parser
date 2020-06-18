require_relative 'helpers/parsed_file'
require_relative 'helpers/api_parser'

directory = 'data/repology'
outdated_repology_packages = []

api_parser = ApiParser.new
packages = api_parser.parse_repology_api('')

last_index = packages.size - 1
response_size = packages.size

while response_size > 1  do
  puts "- Paginating"
  last_package = packages.keys[last_index]
  response = api_parser.parse_repology_api("#{last_package}/")
  response_size = response.size
  packages.merge!(response)
  last_index = packages.size - 1
end

packages.each do |package|
  parsed_outdated_package = {}
  parsed_outdated_package["packagename"] = package[0]


  for project in package[1] do
    result = package[1].find {|item| item["status"] == "newest" or item["status"] == "devel" }


    if project["repo"] == "homebrew" and result != nil
      parsed_outdated_package["newestversion"] = result["version"]
      parsed_outdated_package["srcname"] = project["srcname"]
      parsed_outdated_package["visiblename"] = project["visiblename"]
      parsed_outdated_package["currentversion"] = project["version"]
    end
  end

  outdated_repology_packages.push(parsed_outdated_package)
end

parsed_file = ParsedFile.new
parsed_file.save_to(directory, outdated_repology_packages.join("\n"))
