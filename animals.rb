require './lib/release'

class Animals < Sinatra::Base
  set :root, File.dirname(__FILE__)

  register Sinatra::AssetPack

  assets {
    serve '/js',  from: 'static/coffee'
    serve '/css', from: 'static/sass'
    serve '/img', from: 'static/img'

    css :application, [
      'css/style.css'
    ]

    js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    css_compression :sass     # :simple | :sass | :yui | :sqwish
  }

  get '/' do
    @releases = Release.all.reverse
    haml :index
  end

end