# Include hook code here
require 'csv'
['category_sweeper', 'description_sweeper', 'translated_title_sweeper'].each { |sweeper| require File.join(File.dirname(__FILE__), 'app', 'sweepers', sweeper)  }
# I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales')
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '**', '*.yml')]