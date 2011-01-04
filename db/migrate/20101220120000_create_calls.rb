class CreateCalls < ActiveRecord::Migration
  
  def self.up
    create_table :calls, :id => false do |t|
      t.column :id, 'varchar(32) primary key not null'
      t.boolean :open, :default => false
      t.boolean :reviewable, :default => false
      t.string :title
      t.text :description
      t.date :deadline
      t.string :identity_columns
    end
  end
  
  def self.down
    drop_table :calls
  end
  
end
