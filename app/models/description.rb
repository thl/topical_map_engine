# == Schema Information
# Schema version: 20090731042553
#
# Table name: descriptions
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)      not null
#  content     :text            default(""), not null
#  language_id :integer(4)      not null
#  is_main     :boolean(1)      not null
#  creator_id  :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#  title       :string(255)
#



class Description < ActiveRecord::Base
  validates_presence_of :content, :category_id, :language_id, :creator_id
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  belongs_to :creator, :class_name => 'AuthenticatedSystem::User', :foreign_key => 'creator_id'
  belongs_to :category  
  has_and_belongs_to_many :authors, :class_name => 'AuthenticatedSystem::Person', :join_table => 'authors_descriptions', :association_foreign_key => 'author_id' 
  has_many :sources, :as => :resource 
end
