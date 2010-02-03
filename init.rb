# Include hook code here
require 'csv'

I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales')
require File.join(File.dirname(__FILE__), 'app', 'sweepers', 'category_sweeper')