require 'topical_map_engine/engine'
require 'application_settings'
# Include hook code here
require 'csv'
require 'spelling'
require 'tree'
require 'util'
#['category_sweeper', 'description_sweeper', 'translated_title_sweeper'].each { |sweeper| require File.join(File.dirname(__FILE__), '..', 'app', 'sweepers', sweeper)  }
# I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales')
I18n.load_path += Dir[File.join(__dir__, '..', 'config', 'locales', '**', '*.yml')]

module TopicalMapEngine
end
