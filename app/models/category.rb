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
  
  after_save do |record|
    parent = record.parent
    parent.touch unless parent.nil?
  end
  
  def published_children
    self.children.find(:all, :conditions => {:published => true}, :order => 'title')
  end
  
  def self.published_roots
    self.find(:all, :conditions => {:parent_id => nil, :published => true}, :order => 'title')
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
    
  def media_count
    return @media_count if @media_count
    @media_category_count = MediaCategoryCount.find(:all, :params => {:category_id => self.id}).dup
    @media_count = { 'Medium' => @media_category_count.shift.count.to_i }
    @media_category_count.each{|count| @media_count[count.medium_type] = count.count.to_i }
    return @media_count
  end
  
  def feature_count
    return @feature_count ||= FeatureCategoryCount.find(:all, :params => {:category_id => self.id}).first.count
  end  
end
