# Include hook code here
require 'csv'
require File.join(File.dirname(__FILE__), 'app', 'sweepers', 'category_sweeper')

# I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales')
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '**', '*.yml')]

ActionView::Base.send :include, KmapsEngineHelper