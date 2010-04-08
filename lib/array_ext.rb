class Array
  # Finds the indices of elements that have the same value at the specified key.
  # Perhaps there's a more Ruby way of doing this?
  def duplicate_indices_by_key(key)
    indices = []
    size = self.size
    (0...size).to_a.each do |i|
      (i+1...size).to_a.each do |j|
        indices.push(i, j) if self[i][key] == (self[j][key])
      end
    end
    indices.uniq
  end
end
