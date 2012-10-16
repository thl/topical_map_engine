# == Schema Information
#
# Table name: translated_titles
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  language_id :integer          not null
#  category_id :integer          not null
#  creator_id  :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class TranslatedTitle < ActiveRecord::Base
  attr_accessible :language_id, :title
  validates_presence_of :title, :language_id, :category_id, :creator_id
  validates_uniqueness_of :language_id, :scope => :category_id
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  belongs_to :creator, :class_name => 'AuthenticatedSystem::User', :foreign_key => 'creator_id'
  belongs_to :category
  has_and_belongs_to_many :authors, :class_name => 'AuthenticatedSystem::Person', :join_table => 'authors_translated_titles', :association_foreign_key => 'author_id'
  accepts_nested_attributes_for :authors
end
