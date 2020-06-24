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

formatted_utdated_packages = api_parser.validate_packages(outdated_repology_packages, brew_formulas)

puts formatted_utdated_packages
# homebrew_formula = HomebrewFormula.new
# homebrew_formula.format_data(repology_data, brew_data)

# # An array of hashes. Each hash has name, brew_v, and latest_v keys.
# brew_commands_response = brew_livecheck_and_open_pr_check(repology_data.keys)


# # a hash of hashes
# # hash keys are package names
# # values- {'brew_version: xx', repology_latest: xx, livecheck_latest: xx or not found}
# combined_version_data = compare_version_data(repology_data, brew_data, brew_commands_response)
# display_version_data(combined_version_data)
