require "open3"

class BrewCommands
 
  def livecheck_check_formula(package_name)
    puts "- livecheck verifying formula : #{package_name}"
    command_args = [
      "brew",
      "livecheck",
      package_name,
      "--quiet",
    ]
    Open3.capture2e(*command_args)
  end

  def bump_formula_pr(formula_name, url, checksum)
    command_args = [
      "brew",
      "bump-formula-pr",
      "--no-browse",
      "--dry-run",
      formula_name,
      "--url=#{url}",
      "--sha25=#{checksum}"
    ]

    Open3.capture2e(*command_args)
  end

end