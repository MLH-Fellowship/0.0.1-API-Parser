require_relative 'helpers/api_parser'

def compare_version_data(repology_data, brew_data)
  need_update = {}

  brew_data.each do |pckg|
    name = pckg['name']

    if repology_data[name]
      need_update[name] = {
        'brew_version' => pckg['versions']['stable'],
        'latest_version' => repology_data[name]['latest_v']
      }
    end
  end

  need_update
end

def display_version_data(data)
  data.each do |pckg_name, versions|
    puts ""
    puts "Package: #{pckg_name}"
    puts "current => latest"
    puts "#{versions['brew_version']} => #{versions['latest_version']}"
  end
end

# An hash- each key is the name of a package
# each value is data related to package; of interest: 'latest_v'.
api_parser = ApiParser.new
repology_data = api_parser.filter_homebrew(api_parser.parse_repology_api)

# An array of hashes
# hash keys of interest: 'name' and 'versions'=> 'stable'
homebrew_data = api_parser.query_homebrew

# a hash of hashes
# hash keys are package names
# values are obj {'brew_version: xx', latest_version: xx}
combined_version_data = compare_version_data(repology_data, homebrew_data)
display_version_data(combined_version_data)
