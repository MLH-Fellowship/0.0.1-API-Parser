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
  begin
    tempfile = URI.parse(new_url).open
    tempfile.close
    return Digest::SHA256.file(tempfile.path).hexdigest
  rescue
    return nil
  end
end

repology_file = get_latest_file("data/repology")
homebrew_file = get_latest_file("data/homebrew")
updates_dir = "data/outdated_pckgs_to_update"
no_updates_dir = "data/outdated_pckgs_no_update"
outdated_pckgs_to_update = []
outdated_pckgs_no_update = []

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

      checksum = generate_checksum(new_download_url)

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

# Create directory if does not exist
FileUtils.mkdir_p updates_dir unless Dir.exists?(updates_dir)
FileUtils.mkdir_p no_updates_dir unless Dir.exists?(no_updates_dir)

puts "- Generating datetime stamp"
#Include time to the filename for uniqueness when fetching multiple times a day
date_time = Time.new.strftime("%Y-%m-%dT%H_%M_%S")

# Writing parsed data to file
puts "- Writing data to file"
File.write("#{updates_dir}/#{date_time}.txt", outdated_pckgs_to_update)
File.write("#{no_updates_dir}/#{date_time}.txt", outdated_pckgs_no_update)
