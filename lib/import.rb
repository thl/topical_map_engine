module Import
  def self.categories(root_id, author_id, filename)
    file = File.new(filename)
    csv = File.open(self.csv_filename(filename), 'wb')
    stack = [root_id]
    previous_level = -1
    CSV::Writer.generate(csv, "\t") do |csv|
      file.each do |line|
        level, category_title = self.level_and_title(line)
        level_diff = previous_level - level + 1
        level_diff.times{|i| stack.pop} if level_diff>0
        attrs = {:title => category_title, :parent_id => stack.last, :creator_id => author_id}
        category = Category.first(:conditions => attrs)
        category = Category.create(attrs) if category.nil?
        stack << category.id
        csv << [category.id, category.title]
        previous_level = level
      end
    end
  end
  
  def self.level_and_title(line)
    level = line.chars.find_index{|c| c!="\t"}
    return level, line[level...line.size].strip
  end
  
  def self.csv_filename(filename)
    period = filename.rindex('.')
    period.nil? ? "#{filename}.csv" : "#{filename[0...period]}.csv"
  end
end