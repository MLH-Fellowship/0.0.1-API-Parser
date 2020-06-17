require_relative 'getHomeBrewJson'
require_relative 'getRepologyJson'
# require_relative 'compareHomeBrewAndRepology'

updated_needed = {}
repology_data = filter_homebrew(parse_repology)


homebrew_data = query_homebrew
#repology_data.each { |pckg| puts pckg }
  #p "#{pckg['versions']['stable']} => #{pckg['latest']}" }

# for each
# name
# homebrew v -> xx.xx => latest v -> xx.xx

p repology_data
