class CreateInstructors < ActiveRecord::Migration
  
  def self.up
    create_table :instructors do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, :null => false
      t.string :major
      t.string :status
      t.date :graduation_year
      
      t.text :why_meet
      t.text :programming
      t.text :teaching
      t.text :teamwork
      t.text :anything_else
      
      t.binary :resume
      t.string :resume_id
      
      t.string :how_hear
      
      t.datetime :created_at
    end
    
    say 'create instructor call'
    Call.create(
      :title => 'Apply to Become a MEET Instructor',
      :identity_columns => 'first_name last_name'
    ) { |c| c.id = 'instructor' }
  end
  
  def self.down
    Call.destroy_all(:id => 'instructor')
    drop_table :instructors
  end
  
end
