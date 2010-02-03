# == Schema Information
# Schema version: 20090731042553
#
# Table name: sources
#
#  id            :integer(4)      not null, primary key
#  resource_id   :integer(4)
#  resource_type :string(255)
#  mms_id        :integer(4)
#  volume_number :integer(4)
#  start_page    :integer(4)
#  start_line    :integer(4)
#  end_page      :integer(4)
#  end_line      :integer(4)
#  passage       :text
#  language_id   :integer(4)      not null
#  note          :text
#  creator_id    :integer(4)      not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Source < ActiveRecord::Base
  validates_presence_of :resource_id, :resource_type, :mms_id
  #validates_presence_of :start_page
  validates_presence_of :language_id, :creator_id
  belongs_to :resource, :polymorphic => true 
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  has_many :translated_sources, :dependent => :destroy
end
