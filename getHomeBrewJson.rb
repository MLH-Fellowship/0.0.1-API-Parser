require_relative 'helpers/parsed_file'
require_relative 'helpers/api_parser'

url = 'https://formulae.brew.sh/api/formula.json'
directory = "data/homebrew"
parsed_homebrew_packages = []

api_parser = RepologyApiParser.new
packages = api_parser.call_api(url)

packages.each do |package|
  parsed_homebrew_package = {}
  parsed_homebrew_package['name'] = package["name"]
  parsed_homebrew_package['fullname'] = package["fullname"],
  parsed_homebrew_package['oldname'] = package["oldname"],
  parsed_homebrew_package['versions'] = package["versions"]
  parsed_homebrew_package['download_url'] = package['urls']['stable']['url']
  parsed_homebrew_packages.push(parsed_homebrew_package)
end

parsed_file = ParsedFile.new
parsed_file.save_to(directory, parsed_homebrew_packages.join("\n"))
