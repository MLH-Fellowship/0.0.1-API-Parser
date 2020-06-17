require_relative 'getHomeBrewJson'
require_relative 'getRepologyJson'
require_relative 'compareHomeBrewAndRepology'


# An hash- each key is the name of a package
# each value is data related to package; of interest: 'latest_v'.
repology_data = filter_homebrew(parse_repology)
# An array of hashes
# hash keys of interest: 'name' and 'versions'=> 'stable'
homebrew_data = query_homebrew
# a hash of hashes
# hash keys are package names
# values are obj {'brew_version: xx', latest_version: xx}
combined_version_data = compare_version_data(repology_data, homebrew_data)

display_version_data(combined_version_data)
