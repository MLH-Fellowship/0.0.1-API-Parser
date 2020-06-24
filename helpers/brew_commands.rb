require "open3"

class BrewCommands
 
  def livecheck_check_formula(formula_name)
    puts "- livecheck formula : #{formula_name}"
    command_args = [
      "brew",
      "livecheck",
      formula_name,
      "--quiet",
    ]

    response = Open3.capture2e(*command_args)
    self.parse_livecheck_response(response)
  end

  def bump_formula_pr(formula_name, url, checksum)
    command_args = [
      "brew",
      "bump-formula-pr",
      "--no-browse",
      "--dry-run",
      formula_name,
      "--url=#{url}",
    ]
    Open3.capture2e(*command_args)
  end

  def check_for_open_pr(formula_name)
    puts "- Checking for open PRs for formula : #{formula_name}"

  end

  def parse_livecheck_response(pckg_data)
    parsed_data = {}
  
    pckg_data = pckg_data.first.gsub(' ', '').split(/:|==>|\n/)
    # eg: ["burp", "2.2.18", "2.2.18"]
    pckg_name, brew_version, latest_version = pckg_data
  
    {'name' => pckg_name, 'current_brew_version' => brew_version, 'livecheck_latest_version' => latest_version}
  end

end