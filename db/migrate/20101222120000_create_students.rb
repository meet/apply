class CreateStudents < ActiveRecord::Migration
  
  def self.up
    create_table :students do |t|
      t.string :_student_first_name, :null => false
      t.string :_student_last_name, :null => false
      t.integer :_student_id_number, :null => false
      t.string :_student_gender, :null => false
      t.date :_student_birthday
      t.string :_student_city
      t.string :_student_school
      t.string :_student_address
      t.string :_student_home_phone
      t.string :_student_cell_phone
      t.string :_student_email, :null => false
      
      t.string :_parent_full_name, :null => false
      t.string :_parent_work_phone
      t.string :_parent_cell_phone
      t.string :_parent_email
      
      t.boolean :_permission_to_apply
      
      t.datetime :created_at
    end
    
    say 'create student call'
    Call.create(
      :title => 'Apply to Become a MEET Student',
      :identity_columns => '_student_first_name _student_last_name'
    ) { |c| c.id = 'student' }
  end
  
  def self.down
    Call.destroy_all(:id => 'student')
    drop_table :students
  end
  
end
