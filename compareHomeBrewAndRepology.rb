require_relative 'helpers/parsed_file'
require_relative 'helpers/homebrew_formula'


parsed_file = ParsedFile.new
homebrew_formula = HomebrewFormula.new

repology_file = parsed_file.get_latest_file("data/repology")
homebrew_file = parsed_file.get_latest_file("data/homebrew")
updates_dir = "data/outdated_pckgs_to_update"
no_updates_dir = "data/outdated_pckgs_no_update"

outdated_pckgs_to_update = []
outdated_pckgs_no_update = []

puts "- Comparing Repology file: #{repology_file} to #{homebrew_file}"

File.foreach(repology_file) do |line|
  repology_file_line_hash = eval(line)
  packagename = repology_file_line_hash['srcname']
  newestversion = repology_file_line_hash['newestversion']

  rx = Regexp.new(Regexp.escape(packagename), true)

  IO.foreach(homebrew_file) do |line|
    if line[rx]
      line_hash = eval(line)
      
      if line_hash["name"] == packagename 
        package = {}
        puts line_hash
        puts "\n"

        package["name"] = line_hash["name"]
        prev_version = line_hash['versions']['stable']
        prev_download_url = line_hash['download_url']
        
        package["latest_version"] = newestversion
        package["old_url"] = prev_download_url

        new_download_url = homebrew_formula.generate_new_download_url(prev_download_url, prev_version, newestversion)
        checksum = homebrew_formula.generate_checksum(new_download_url)

        if checksum
          package["download_url"] = new_download_url
          package["checksum"] = checksum
  
          outdated_pckgs_to_update.push(package)
        else
          outdated_pckgs_no_update.push(package)
        end
      end
    end
  end
end

parsed_file.save_to(updates_dir, outdated_pckgs_to_update.join("\n"))
parsed_file.save_to(no_updates_dir, outdated_pckgs_no_update.join("\n"))

