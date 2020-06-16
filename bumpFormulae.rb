require_relative 'helpers/parsed_file'
require_relative 'helpers/brew_commands.rb'

brew_commands = BrewCommands.new

parsed_file = ParsedFile.new
outdated_pckgs_to_update = parsed_file.get_latest_file("data/outdated_pckgs_to_update")

File.foreach(outdated_pckgs_to_update) do |line|
  line_hash = eval(line)
  puts "\n- bumping package: #{line_hash['name']} formula"

  begin
    livecheck_response, livecheck_status = brew_commands.livecheck_check_formula(line_hash['name'])
    splitResponse = livecheck_response.split('==>')
    liveCheckNewVersion = splitResponse[1]

    if liveCheckNewVersion == line_hash['latest_version']
      puts "- #{line_hash['name']} livecheck new version matches repology latest version"
    else
      puts "- #{line_hash['name']} repology latest version(#{line_hash['latest_version']}) doesn't match with livecheck new version(#{liveCheckNewVersion})"
    end

    bump_pr_response, bump_pr_status = brew_commands.bump_formula_pr(line_hash['name'], line_hash['download_url'], line_hash['checksum'])
    puts "#{bump_pr_response}"
  rescue
    puts "- An error occured whilst bumping package #{line_hash['name']} \n"
    return nil
  end
end
