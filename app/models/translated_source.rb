# == Schema Information
#
# Table name: translated_sources
#
#  id          :integer          not null, primary key
#  title       :text             default(""), not null
#  language_id :integer          not null
#  source_id   :integer          not null
#  creator_id  :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class TranslatedSource < ActiveRecord::Base
  attr_accessible :language_id, :title
  validates_presence_of :title, :language_id, :source_id, :creator_id
  validates_uniqueness_of :language_id, :scope => :source_id
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  belongs_to :creator, :class_name => 'AuthenticatedSystem::User', :foreign_key => 'creator_id'
  belongs_to :source
  has_and_belongs_to_many :authors, :class_name => 'AuthenticatedSystem::Person', :join_table => 'authors_translated_sources', :association_foreign_key => 'author_id'
  accepts_nested_attributes_for :authors
end
