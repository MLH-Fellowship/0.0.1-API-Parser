require_relative 'helpers/api_parser'
require_relative 'helpers/brew_commands'
require_relative 'helpers/homebrew_formula'



def display_version_data(data)
  data.each do |pckg_name, versions|
    puts ""
    puts "Package: #{pckg_name}"
    puts "Brew current: #{versions['brew_version']}"
    puts "Repology latest: #{versions['repology_latest']}"
    puts "Livecheck latest: #{versions['livecheck_latest']}"
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

puts formatted_outdated_packages
