class CreateFellows < ActiveRecord::Migration
  
  def self.up
    create_table :fellows do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, :null => false
      t.string :major
      t.string :affiliation
      
      t.text :why_fellow
      t.text :challenges
      t.text :role
      t.text :foreign
      t.text :mission
      
      t.string :resume_file_name
      
      t.string :how_hear
      
      t.datetime :created_at
    end
    
    say 'create fellow call'
    Call.create(
      :title => 'Apply to Become a MEET Fellow',
      :identity_columns => 'first_name last_name'
    ) { |c| c.id = 'fellow' }
  end
  
  def self.down
    Call.destroy_all(:id => 'fellow')
    drop_table :fellows
  end
  
end
