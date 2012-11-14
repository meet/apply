require 'test_helper'
require 'test_integration_helper'

class StudentFlowsTest < AppIntegrationTest
  
  test_submit_and_review_application('student') do |test|
    [
      field(:_student_first_name, 'Tim'),
      field(:_student_last_name, 'the Beaver'),
      field(:_student_id_number, 909909090),
      field(:_student_gender, 'Male'),
      field(:_student_birthday, Date.new(1861, 4, 10)),
      field(:_student_city, 'Jerusalem'),
      field(:_student_school, 'MITx High School'),
      field(:_student_address, '77 Massachusetts Avenue'),
      field(:_student_home_phone, '123'),
      field(:_student_cell_phone, '123'),
      field(:_student_email, 'timthebeaver@meet.mit.edu'),
      field(:_parent_full_name, 'William Barton Rogers'),
      field(:_parent_work_phone, '123'),
      field(:_parent_cell_phone, '123'),
      field(:_parent_email, 'williambartonrogersfovnder@meet.mit.edu'),
      field(:_permission_to_apply, true)
    ]
  end
  
end
