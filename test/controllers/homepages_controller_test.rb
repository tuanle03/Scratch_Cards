require "test_helper"

class HomepagesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get homepages_show_url
    assert_response :success
  end
end
