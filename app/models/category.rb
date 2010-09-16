# == Schema Information
# Schema version: 20090731042553
#
# Table name: categories
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)     not null
#  parent_id  :integer(4)
#  creator_id :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#  published  :boolean(1)      not null
#  cumulative :boolean(1)      default(TRUE), not null
#

class Category < ActiveRecord::Base
  validates_presence_of :title, :creator_id
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  #belongs_to :curator, :class_name => 'Person', :foreign_key => 'curator_id'
  has_and_belongs_to_many :curators, :class_name => 'Person', :join_table => 'categories_curators', :association_foreign_key => 'curator_id'
  has_many :translated_titles, :dependent => :destroy
  has_many :descriptions, :dependent => :destroy
  has_many :sources, :as => :resource 
  acts_as_tree :order => 'title'
  include Tree
  
  def published_children
    self.children.find(:all, :conditions => {:published => true}, :order => 'title')
  end
  
  def self.published_roots
    self.find(:all, :conditions => {:parent_id => nil, :published => true}, :order => 'title')
  end

  def self.published_roots_and_descendants
    self.published_roots.inject([]){ |descendants, root| descendants.concat(root.self_and_descendants) }
  end
  
  def children_with_descendants
    stack = [self] + children.collect { |c| c }
    result = []
    while !stack.empty?
      child = stack.pop
      result << [child.full_lineage(10), child.id]
      child.children.each {|c| stack.push c }
    end
    result
  end

  def self_and_descendants
    [self] + children.collect{|c| c.self_and_descendants}
  end
    
  def media_count(options = {})
    media_count_hash = Rails.cache.fetch("#{self.cache_key}/media_count") do
      media_category_count = MediaCategoryCount.find(:all, :params => {:category_id => self.id}).dup
      media_count_hash = { 'Medium' => media_category_count.shift.count.to_i }
      media_category_count.each{|count| media_count_hash[count.medium_type] = count.count.to_i }
      media_count_hash
    end
    type = options[:type]
    return type.nil? ? media_count_hash['Medium'] : media_count_hash[type]
  end
  
  def feature_count
    Rails.cache.fetch("#{self.cache_key}/feature_count") do
      FeatureCategoryCount.find(:all, :params => {:category_id => self.id}).first.count
    end
  end
  
  def shape_count
    Rails.cache.fetch("#{self.cache_key}/shape_count") do
      FeatureCategoryCount.find(:all, :params => {:category_id => self.id}).first.count_with_shapes
    end
  end
  
  def media_url
    MediaManagementResource.get_url + topic_path
  end
  
  def places_url
    PlacesResource.get_url + topic_path
  end
  
  def self.find_all_by_feature_id(feature_id)
    Feature.find(feature_id).feature_type_ids.collect{|id| Category.find(id)}
  end
  
  def self.find_all_by_medium_id(medium_id)
    Medium.find(medium_id).category_ids.collect{|id| Category.find(id)}
  end
  
  private
  
  def topic_path
    ['topics', self.id].join('/')
  end
end
