module KmapsEngine
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile << 'customtinymce.css'
    end
  end
end
