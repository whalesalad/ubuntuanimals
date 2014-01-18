require 'csv'
require 'yaml'
require 'open-uri'
require 'subexec'
require './lib/release'

PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))
MAX_IMAGE_DIMENSION = 1000

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

namespace :images do
  desc "Grab images and save them to static/img"
  task :fetch do
    dest_dir = File.join(PROJECT_ROOT, 'static', 'img', 'releases')

    Release.all.each do |r|
      dest = File.join(dest_dir, "#{r.short_name}.jpg")

      puts "Fetching photo for #{r}"
      puts "  <- src '#{r.photo}'"
      puts "  -> dst '#{dest}'"

      begin
        open(dest, 'wb') do |file|
          file << open(r.photo).read
        end
      rescue
        puts "FAILURE"
      end

      puts

      sleep 2
    end
  end

  desc "Resize the release images"
  task :resize do
    img_dir = File.join(PROJECT_ROOT, 'static', 'img', 'releases')
    Subexec.run "mogrify -resize #{MAX_IMAGE_DIMENSION}x#{MAX_IMAGE_DIMENSION} #{img_dir}/*.jpg"
  end
end