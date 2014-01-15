require 'csv'
require 'yaml'

PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))

desc "Generate output for releases.yml from lib/releases.csv"
task :generate_yaml do
  csv_file = File.join(PROJECT_ROOT, 'lib', 'data', 'releases.csv')

  releases = {}

  CSV.foreach(csv_file) do |row|
    next if row[0] == 'Version'
    short_name = row[1].split(' ').first.downcase
    releases[short_name] = {
      version: row[0],
      name: row[1],
      lts: row[2] == 'LTS',
      released: row[3],
      supported_until: row[4],
      kernel_version: row[5],
      photo: row[6]
    }
  end

  puts releases.to_yaml
end