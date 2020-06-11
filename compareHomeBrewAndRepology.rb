require 'json'
require 'fileutils'
require 'open-uri'


def get_latest_file(directory)
  puts "- retrieving latest file in directory: #{directory}"
  Dir.glob("#{directory}/*").max_by(1) {|f| File.mtime(f)}[0]
end

def new_download_url(outdated_url, old_version, latest_version)
  outdated_url.gsub(old_version, latest_version)
end

def generate_checksum(new_url)
  tempfile = URI.parse(new_url).open
  tempfile.close
  Digest::SHA256.file(tempfile.path).hexdigest
end

repology_file = get_latest_file("data/repology")
homebrew_file = get_latest_file("data/homebrew")
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

      package["name"] = line_hash["name"]
      package["latest_version"] = newestversion
      package["old_url"] = prev_download_url
      package["download_url"] = new_download_url
      outdated_package_list.push(package)
    end
  end
end

# Create directory if does not exist
FileUtils.mkdir_p directory unless Dir.exists?(directory)

puts "- Generating datetime stamp"
#Include time to the filename for uniqueness when fetching multiple times a day
date_time = Time.new.strftime("%Y-%m-%dT%H_%M_%S")

# Writing parsed data to file
puts "- Writing data to file"
File.write("#{directory}/#{date_time}.txt", outdated_package_list)
