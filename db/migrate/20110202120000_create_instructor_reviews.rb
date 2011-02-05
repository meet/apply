class CreateInstructorReviews < ActiveRecord::Migration
  
  def self.up
    create_table :instructor_reviews do |t|
      t.string :app_reviewer_id, :null => false
      t.integer :app_id, :null => false
      
      t.integer :enthusiasm
      t.integer :programming
      t.integer :teaching
      t.integer :teamwork
      t.integer :overall
      t.boolean :y1
      t.boolean :y2
      t.boolean :y3
      t.boolean :interview
      t.text :comment
      
      t.datetime :created_at
    end
    add_index :instructor_reviews, [ :app_reviewer_id, :app_id ], :unique => true
  end
  
  def self.down
    drop_table :instructor_reviews
  end
  
end
