require 'json'
require 'fileutils'
require 'open-uri'
require_relative 'helpers/parsed_file'

def new_download_url(outdated_url, old_version, latest_version)
  puts "- Generating download url"
  outdated_url.gsub(old_version, latest_version)
end

def generate_checksum(new_url)
  begin
    puts "- Generating checksum for url: #{new_url}"
    tempfile = URI.parse(new_url).open
    tempfile.close
    return Digest::SHA256.file(tempfile.path).hexdigest
  rescue
    puts "- Failed to generate Checksum"
    return nil
  end
end

parsed_file = ParsedFile.new
repology_file = parsed_file.get_latest_file("data/repology")
homebrew_file = parsed_file.get_latest_file("data/homebrew")

directory = "data/outdatedpacakges"
outdated_package_list = []

puts "- Comparing Repology file: #{repology_file} to #{homebrew_file}"

File.foreach(repology_file) do |line|
  line_hash = eval(line)
  packagename = line_hash['packagename']
  newestversion = line_hash['newestversion']

  rx = Regexp.new(Regexp.escape(packagename), true)

  IO.foreach(homebrew_file) do |line|
    if line[rx]
      line_hash = eval(line)
      package = {}
      prev_version = line_hash['versions']['stable']
      prev_download_url = line_hash['download_url']
      new_download_url = new_download_url(prev_download_url, prev_version, newestversion)

      checksum = generate_checksum(new_download_url)

      if line_hash["name"] == packagename and checksum
        package["name"] = line_hash["name"]
        package["latest_version"] = newestversion
        package["old_url"] = prev_download_url
        package["download_url"] = new_download_url
        package["checksum"] = checksum
        outdated_package_list.push(package)
      end
    end
  end
end

generate_checksum("https://github.com/witten/borgmatic/archive/1.5.6.tar.gz")

parsed_file.save_to(directory, outdated_package_list)

