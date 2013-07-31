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
#  oral          :string(255)
#  taken_on      :datetime
#

class Source < ActiveRecord::Base
  attr_accessible :mms_id, :oral, :volume_number, :start_page, :start_line, :end_page, :end_line, :language_id, :passage, :note, :taken_on
  
  validates_presence_of :resource_id, :resource_type
  #validates_presence_of :start_page
  validates_presence_of :language_id, :creator_id
  validate :mms_id_or_oral
  belongs_to :resource, :polymorphic => true 
  belongs_to :creator, :class_name => 'AuthenticatedSystem::User', :foreign_key => 'creator_id'
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  has_many :translated_sources, :dependent => :destroy
  
  def formatted
    if mms_id.blank?
      str = "#{Source.human_attribute_name(:oral).s}: #{self.oral}"
      str << " (#{self.taken_on.to_date.to_formatted_s(:long)})" if !self.taken_on.nil?
      return str
    end
    str = "#{Source.human_attribute_name(:mms_id).s} \##{self.mms_id}" 
    pages_str = self.start_page.to_s
    if !self.start_line.nil?
      pages_str << ".#{self.start_line}"
    end
    if !self.end_page.nil? or !self.end_line.nil?
      pages_str << '-'
      if !self.end_page.nil?
        pages_str << self.end_page.to_s
      end
      if !self.end_line.nil?
        pages_str << ".#{self.end_line}."
      end
    end
    str << ", #{pages_str}" if !pages_str.blank?
    return str
  end
  
  private
  
  def mms_id_or_oral
    if !(mms_id.blank? ^ oral.blank?)
      errors[:base] << 'Specify either an MMS ID or an oral source, but not both'
    end
  end
end
