require_relative 'getHomeBrewJson'
require_relative 'getRepologyJson'
# require_relative 'compareHomeBrewAndRepology'

repology_data = filter_homebrew(parse_repology)
homebrew_data = query_homebrew
p(homebrew_data)
