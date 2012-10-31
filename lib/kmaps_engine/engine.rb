module KmapsEngine
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile << 'kmaps_engine/iframe.js'
    end
  end
end
