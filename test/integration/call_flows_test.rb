require 'test_helper'

class CallFlowsTest < ActionController::IntegrationTest
  
  test "index should show calls after login" do
    open_session do |s|
      s.extend(OpenIdAuthorization::MockOpenIdFetcher::Session)
      s.https!
      s.login '/calls', 'tom', 'allstaff'
      s.assert_select 'a[href=?]', call_path(calls(:panda))
      s.assert_select 'a[href=?]', apply_path(calls(:panda))
      s.assert_select 'a[href=?]', review_path(calls(:panda))
    end
  end
  
end
