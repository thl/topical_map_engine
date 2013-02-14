module KmapsEngine
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile.concat(['kmaps_engine/iframe.js', 'interface_utils/jquery-ui-1.8.24.custom.min.js', 'kmaps_engine/parent-popup-ui-handler.js', 'interface_utils/jquery-ui-1.8.24.custom.css'])
    end
  end
end
