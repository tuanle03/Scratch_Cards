require "test_helper"

class RoomsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get rooms_create_url
    assert_response :success
  end
end
