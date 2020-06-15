require_relative 'helpers/brew_commands.rb'

brew_commands = BrewCommands.new

package = {
  "download_url" => "https://github.com/pazz/alot/archive/0.9.1.tar.gz",
  "name" => "alot",
  "latest_version" => "0.9.1",
  "checksum" => "ee2c1ab1b43d022a8fe2078820ed57d8d72aec260a7d750776dac4ee841d1de4"
}

livecheck_response, livecheck_status = brew_commands.livecheck_check_formula(package['name'])
# puts "#{livecheck_response} - #{livecheck_status}"

splitResponse = livecheck_response.split('==>')
liveCheckNewVersion = splitResponse[1]

bump_pr_response, bump_pr_status = brew_commands.bump_formula_pr(package['name'], package['download_url'], package['checksum'])
puts "#{bump_pr_response} - #{bump_pr_status}"

# puts response