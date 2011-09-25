class UsePaperclip < ActiveRecord::Migration
  
  def self.up
    remove_column :instructors, :resume
    rename_column :instructors, :resume_id, :resume_file_name
    
    remove_column :businesses, :resume
    rename_column :businesses, :resume_id, :resume_file_name
  end
  
  def self.down
    rename_column :instructors, :resume_file_name, :resume_id
    add_column :instructors, :resume, :binary, :after => :anything_else
    
    rename_column :businesses, :resume_file_name, :resume_id
    add_column :businesses, :resume, :binary, :after => :anything_else
  end
  
end
