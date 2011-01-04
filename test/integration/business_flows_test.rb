require 'test_helper'
require 'test_integration_helper'

class BusinessFlowsTest < AppIntegrationTest
  
  test_submit_and_review_application('business') do |test|
    [
      field(:first_name, 'Tim'),
      field(:last_name, 'the Beaver'),
      field(:email, 'timthebeaver@meet.mit.edu'),
      field(:major, 'MBA'),
      field(:graduation_year, Date.new(2010, 1, 1)),
      field(:why_meet, 'MEET is awesome.'),
      field(:experience, 'Football games.'),
      field(:teamwork, 'Only the strong survive.'),
      field(:limitations, 'May need to block some rivers.'),
      field(:anything_else, 'Dam.'),
      field(:resume, test.fixture_file_upload('files/resume.pdf', 'application/pdf')),
      field(:how_hear, 'Some guy in a beaver suit told me')
    ]
  end
  
end
