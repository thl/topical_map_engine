class Blurb < ActiveRecord::Base
  after_save { |record| Rails.cache.delete("blurbs/#{record.code}") }
  
  def self.get_by_code(code)
    Rails.cache.fetch("blurbs/#{code}") { self.find_by_code(code) }
  end
end
