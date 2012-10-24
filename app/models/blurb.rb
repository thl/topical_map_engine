# == Schema Information
#
# Table name: blurbs
#
#  id         :integer          not null, primary key
#  code       :string(255)      not null
#  title      :string(255)      not null
#  content    :text             default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

class Blurb < ActiveRecord::Base
  attr_accessible :code, :title, :content
  after_save { |record| Rails.cache.delete("blurbs/#{record.code}") }
  
  def self.get_by_code(code)
    Rails.cache.fetch("blurbs/#{code}", :expires_in => 1.day) { self.find_by_code(code) }
  end
end
