require "test_helper"

class Admin::RestaurantsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_restaurants_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_restaurants_show_url
    assert_response :success
  end
end
