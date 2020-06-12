require_relative 'helpers/brew_commands.rb'

brew_commands = BrewCommands.new

livecheck_response, livecheck_status = brew_commands.livecheck_check_formula('acmetool')
puts "#{livecheck_response} - #{livecheck_status}"

bump_pr_response, bump_pr_status = brew_commands.bump_formula_pr('acmetool')
puts "#{bump_pr_response} - #{bump_pr_status}"

puts response