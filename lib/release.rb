require 'yaml'
require 'time'

DATA_ROOT = File.join(File.expand_path(File.dirname(__FILE__)), 'data')

class Release
  def self.releases
    @releases ||= begin
      YAML.load_file(File.join(DATA_ROOT, 'releases.yml')).tap do |r|
        r.each { |k, v| r[k] = new(k, v) }
      end
    end
  end

  def self.all
    releases.values
  end

  def self.get(short_name)
    releases[short_name]
  end

  #

  attr_reader :attributes, :short_name

  def initialize(short_name, attributes)
    @short_name = short_name
    @attributes = attributes
  end

  def to_s
    "#{name}, #{version}".tap { |s| s << " LTS" if lts }
  end

  def released
    Time.strptime(super, "%D")
  end

  def supported_until
    Time.strptime(super, "%D") if super
  end

  def released?
    released < Time.now
  end

  def supported?
    return false unless supported_until
    supported_until > Time.now
  end

  def supported_months_remaining
    (supported_until.year * 12 + supported_until.month) - (Time.now.year * 12 + Time.now.month)
  end

  def photo
    "/img/releases/#{short_name}.jpg"
  end

  protected

  def method_missing(method_symbol, *arguments)
    method_name = method_symbol.to_s

    if method_name =~ /(=|\?)$/
      case $1
      when "="
        attributes[$`] = arguments.first
      when "?"
        attributes[$`]
      end
    else
      return attributes[method_name.to_sym] if attributes.include?(method_name.to_sym)
      super
    end
  end

end