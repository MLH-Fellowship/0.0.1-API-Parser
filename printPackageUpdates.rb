require_relative 'helpers/api_parser'
require_relative 'helpers/brew_commands'

def compare_version_data(repology_data, brew_data, lc_data)
  need_update = {}

  brew_data.each do |pckg|
    name = pckg['name']

    if repology_data[name]
      lc_latest = lc_data[name] ? lc_data[name]['latest_v'] : 'Not found'

      need_update[name] = {
        'brew_version' => pckg['versions']['stable'],
        'repology_latest' => repology_data[name]['latest_v'],
        'livecheck_latest' => lc_latest
      }
    end
  end

  need_update
end

def display_version_data(data)
  data.each do |pckg_name, versions|
    puts ""
    puts "Package: #{pckg_name}"
    puts "Brew current: #{versions['brew_version']}"
    puts "Repology latest: #{versions['repology_latest']}"
    puts "Livecheck latest: #{versions['livecheck_latest']}"
  end
end

def parse_livecheck_pckg_data(pckg_data)
  parsed_data = {}

  pckg_data = pckg_data.first.gsub(' ', '').split(/:|==>|\n/)
  # eg: ["burp", "2.2.18", "2.2.18"]
  pckg_name, brew_version, latest_version = pckg_data

  {'name' => pckg_name, 'brew_v' => brew_version, 'latest_v' => latest_version}
end

def retrieve_livecheck_version_data(repology_data)
  data = {}
  livecheck = BrewCommands.new
  repology_data.each do |pckg|
    pckg_data = livecheck.livecheck_check_formula(pckg)
    pckg_data = parse_livecheck_pckg_data(pckg_data)
    data[pckg_data['name']] = {'brew_v' => pckg_data['brew_v'], 'latest_v' => pckg_data['latest_v']}
  end

  data
end
# A hash- each key is the name of a package
# each value is data related to package; of interest: 'latest_v'.
api_parser = ApiParser.new
repology_data = api_parser.filter_homebrew(api_parser.parse_repology_api)

# An array of hashes
# hash keys of interest: 'name' and 'versions'=> 'stable'
brew_data = api_parser.query_homebrew

# An array of hashes. Each hash has name, brew_v, and latest_v keys.
livecheck_data = retrieve_livecheck_version_data(repology_data.keys)

# a hash of hashes
# hash keys are package names
# values- {'brew_version: xx', repology_latest: xx, livecheck_latest: xx or not found}
combined_version_data = compare_version_data(repology_data, brew_data, livecheck_data)
display_version_data(combined_version_data)
