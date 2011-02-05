# Zookeeper application and review tables
class CreateZookeepers < ActiveRecord::Migration
  def self.up
    create_table :zookeepers, :force => true do |t|
      t.string :name
      t.datetime :created_at
    end
    
    create_table :zookeeper_reviews, :force => true do |t|
      t.string :app_reviewer_id, :null => false
      t.integer :app_id, :null => false
      
      t.integer :experience
      t.integer :panda_whispering
      t.boolean :lions
      t.boolean :tigers
      t.text :comment
      
      t.datetime :created_at
    end
  end
end

CreateZookeepers.verbose = false
CreateZookeepers.migrate(:up)
