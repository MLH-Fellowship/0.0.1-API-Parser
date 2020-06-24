require_relative 'helpers/api_parser'
require_relative 'helpers/brew_commands'
require_relative 'helpers/homebrew_formula'



def display_version_data(data)
  data.each do |pckg_name, pckg_data|
    puts ""
    puts "Package: #{pckg_name}"
    puts "Brew current: #{pckg_data['homebrew_version']}"
    puts "Repology latest: #{pckg_data['repology_version']}"
    puts "Livecheck latest: #{pckg_data['livecheck_latest_version']}"
  end
end


# A hash- each key is the name of a package
# each value is data related to package; of interest: 'latest_v'.
api_parser = ApiParser.new
outdated_repology_packages = api_parser.parse_repology_api()

# An array of hashes
# hash keys of interest: 'name' and 'versions'=> 'stable'
brew_formulas = api_parser.parse_homebrew_formulas()

formatted_outdated_packages = api_parser.validate_packages(outdated_repology_packages, brew_formulas)

puts "==============Formatted outdated packages============\n"
puts "#{formatted_outdated_packages}\n\n"

display_version_data(formatted_outdated_packages)
