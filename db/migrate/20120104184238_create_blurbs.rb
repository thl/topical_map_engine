class CreateBlurbs < ActiveRecord::Migration
  def self.up
    create_table :blurbs do |t|
      t.string :code, :null => false
      t.string :title, :null => false
      t.text :content, :null => false
      t.timestamps
    end
    Blurb.create :code => 'home', :title => 'Knowledge Maps of Subjects', :content => '<p>Knowledge Maps present annotated hierarchies that "map" out a subject, such as rituals or geographical feature types, and then link each subject to corresponding places, photographs, audio-video, and other such resources</p>'
  end

  def self.down
    drop_table :blurbs
  end
end
