require 'net/http'
require 'json'

class RepologyApiParser

  def call_api(url)
    puts "- Calling API #{url}"
    uri = URI(url)
    response = Net::HTTP.get(uri)

    puts "- Parsing response"
    JSON.parse(response)
  end

  def parse_repology_api(last_package)
    url = 'https://repology.org/api/v1/projects/' + last_package + '?inrepo=homebrew&outdated=1'

    self.call_api(url)
  end

  def filter_homebrew(json)
    result = {}

    json.each do |pckg, data|
      homebrew_data = data.select { |repo| repo['repo'] == 'homebrew' }[0]
      latest_v = nil

      data.each do |datum|
        latest_v = datum['version'] if datum['status'] == 'newest'
      end

      homebrew_data['latest_v'] = latest_v if latest_v
      result[pckg] = homebrew_data if !homebrew_data.empty?
    end

    result
  end
end
