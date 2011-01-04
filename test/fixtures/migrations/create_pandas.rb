# Panda application table
class CreatePandas < ActiveRecord::Migration
  def self.up
    create_table :pandas, :force => true do |t|
      t.string :name
      t.date :birthday
      t.date :favorite_bamboo_vintage_year
      t.text :experience
      t.boolean :cute
      t.binary :photo
      t.string :photo_id
      t.datetime :created_at
    end
  end
end

CreatePandas.verbose = false
CreatePandas.migrate(:up)
