# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  parent_id  :integer
#  creator_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  published  :boolean          default(FALSE), not null
#  cumulative :boolean          default(TRUE), not null
#

class Category < ActiveRecord::Base
  attr_accessible :title, :parent_id, :published, :cumulative, :curator_ids
  
  validates_presence_of :title, :creator_id
  belongs_to :creator, :class_name => 'AuthenticatedSystem::User', :foreign_key => 'creator_id'
  #belongs_to :curator, :class_name => 'AuthenticatedSystem::Person', :foreign_key => 'curator_id'
  has_and_belongs_to_many :curators, :class_name => 'AuthenticatedSystem::Person', :join_table => 'categories_curators', :association_foreign_key => 'curator_id'
  has_many :translated_titles, :dependent => :destroy
  has_many :descriptions, :dependent => :destroy
  has_many :sources, :as => :resource 
  acts_as_tree :order => 'title' if Category.table_exists?
  include Tree
  
  def published_children
    self.children.where(:published => true).order('title')
  end
  
  def self.published_roots
    self.where(:parent_id => nil, :published => true).order('title')
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
  
  def mediabase_count
    m = Rails.cache.fetch("#{self.cache_key}/mediabase", :expires_in => 1.day) do
      MediabaseCategoryCount.find(self.id)
    end
    return 0 if m.nil?
    return m[:kmap_count].to_i
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
  
  def mediabase_url
    m = Rails.cache.fetch("#{self.cache_key}/mediabase", :expires_in => 1.day) do
      MediabaseCategoryCount.find(self.id)
    end
    return nil if m.nil?
    return "#{MediabaseResource.site.to_s}/#{m[:view_uri]}"
  end
  
  def media_url
    MediaManagementResource.get_url + topic_path
  end

  def pictures_url
    MediaManagementResource.get_url + topic_path('pictures')
  end

  def videos_url
    MediaManagementResource.get_url + topic_path('videos')
  end

  def documents_url
    MediaManagementResource.get_url + topic_path('documents')
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
  
  def topic_path(type = nil)
    a = ['topics', self.id]
    a << type if !type.nil?
    a.join('/')
  end
end
