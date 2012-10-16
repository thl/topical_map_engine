# == Schema Information
#
# Table name: sources
#
#  id            :integer          not null, primary key
#  resource_id   :integer
#  resource_type :string(255)
#  mms_id        :integer
#  volume_number :integer
#  start_page    :integer
#  start_line    :integer
#  end_page      :integer
#  end_line      :integer
#  passage       :text
#  language_id   :integer          not null
#  note          :text
#  creator_id    :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Source < ActiveRecord::Base
  attr_accessible :mms_id, :volume_number, :start_page, :start_line, :end_page, :end_line, :language_id, :passage, :note
  
  validates_presence_of :resource_id, :resource_type, :mms_id
  #validates_presence_of :start_page
  validates_presence_of :language_id, :creator_id
  belongs_to :resource, :polymorphic => true 
  belongs_to :creator, :class_name => 'AuthenticatedSystem::User', :foreign_key => 'creator_id'
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  has_many :translated_sources, :dependent => :destroy
end
