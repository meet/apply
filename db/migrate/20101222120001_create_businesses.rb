class CreateBusinesses < ActiveRecord::Migration
  
  def self.up
    create_table :businesses do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, :null => false
      t.string :major
      t.date :graduation_year
      
      t.text :why_meet
      t.text :experience
      t.text :teamwork
      t.text :limitations
      t.text :anything_else
      
      t.binary :resume
      t.string :resume_id
      
      t.string :how_hear
      
      t.datetime :created_at
    end
    
    say 'create business call'
    Call.create(
      :title => 'Apply to Become a MEET Business Instructor',
      :identity_columns => 'first_name last_name'
    ) { |c| c.id = 'business' }
  end
  
  def self.down
    Call.destroy_all(:id => 'business')
    drop_table :businesses
  end
  
end
