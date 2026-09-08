require "test_helper"

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get repositories_index_url
    assert_response :success
  end

  test "should get show" do
    get repositories_show_url
    assert_response :success
  end

  test "should get update" do
    get repositories_update_url
    assert_response :success
  end
end
