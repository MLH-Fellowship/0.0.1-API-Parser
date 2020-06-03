require 'json'

unPrettyFile = File.open 'repology-JSON/unformatted/latest.json'

unPrettyData = JSON.load unPrettyFile

writePretty = JSON.pretty_generate(unPrettyData)

File.write('repology-JSON/formatted/latest.json', writePretty)

unPrettyFile.close
