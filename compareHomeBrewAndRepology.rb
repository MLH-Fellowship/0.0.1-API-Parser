require 'json'
require 'fileutils'


def get_latest_file(directory)
  puts "- retrieving latest file in directory: #{directory}"
  Dir.glob("#{directory}/*").max_by(1) {|f| File.mtime(f)}[0]
end

repology_file = get_latest_file("data/repology")
homebrew_file = get_latest_file("data/homebrew")
directory = "data/outdatedpacakges"
outdated_package = []

puts "- Comparing Repology file: #{repology_file} to #{homebrew_file}"
File.foreach(repology_file) { |line|
  line_hash = eval(line) 
  packagename = line_hash['packagename']
  newestversion  = line_hash['newestversion']

  rx = Regexp.new(Regexp.escape(packagename), true)

  IO.foreach(homebrew_file) do |line|
    if line[rx]
      line_hash = eval(line) 
      package = line_hash["name"] + "(" + newestversion + ")"
      outdated_package.push(package)
    end
  end
 
}

# puts outdated_package_names

# Create directory if does not exist
FileUtils.mkdir_p directory unless Dir.exists?(directory)

puts "- Generating datetime stamp"
#Include time to the filename for uniqueness when fetching multiple times a day
date_time = Time.new.strftime("%Y-%m-%dT%H_%M_%S")

# Writing parsed data to file
puts "- Writing data to file"
File.write("#{directory}/#{date_time}.txt", outdated_package.join("\n"))
