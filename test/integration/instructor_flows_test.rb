require 'test_helper'
require 'test_integration_helper'

class InstructorFlowsTest < AppIntegrationTest
  
  test_submit_and_review_application('instructor') do |test|
    [
      field(:first_name, 'Tim'),
      field(:last_name, 'the Beaver'),
      field(:email, 'timthebeaver@meet.mit.edu'),
      field(:major, 'XVIII-C'),
      field(:status, 'Undergraduate'),
      field(:graduation_year, Date.new(2000, 1, 1)),
      field(:why_meet, 'MEET is awesome.'),
      field(:programming, "I've used Datalog, Prolog, and Verilog."),
      field(:teaching, 'Nature is my teacher.'),
      field(:teamwork, 'Only the strong survive.'),
      field(:anything_else, 'Dam.'),
      field(:resume, test.fixture_file_upload('files/resume.pdf', 'application/pdf')),
      field(:how_hear, 'Some guy in a beaver suit told me')
    ]
  end
  
end
