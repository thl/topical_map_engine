module KmapsEngine
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile.concat(['kmaps_engine/iframe.js', 'kmaps_engine/jquery-ui-1.8.24.custom.min.js', 'kmaps_engine/popup-ui-handler.js', 'kmaps_engine/jquery-ui-1.8.24.custom.css'])
    end
  end
end
