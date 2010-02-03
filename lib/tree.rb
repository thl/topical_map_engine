module Tree
  def descendants
    children_to_be_processed = [self]
    all_children = Array.new
    while !children_to_be_processed.empty?
      child = children_to_be_processed.shift
      all_children.push child.id
      children_to_be_processed.concat(child.children)
    end
    all_children
  end
  
  def full_lineage(size = nil)
    parent = self.parent
    lineage = [self.title]
    while !parent.nil?
      lineage.unshift(size==nil ? parent.title : "#{parent.title[0...size]}...")
      parent = parent.parent
    end
    return lineage.join(' > ')
  end
end