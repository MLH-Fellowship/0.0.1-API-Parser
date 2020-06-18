require 'net/http'
require 'json'

class ApiParser

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

  

end
