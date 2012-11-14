# Veterinarian application table
class CreateVeterinarians < ActiveRecord::Migration
  def self.up
    create_table :veterinarians, :force => true do |t|
      t.string :name
      t.string :specialty
      t.datetime :created_at
    end
  end
end

CreateVeterinarians.verbose = false
CreateVeterinarians.migrate(:up)
