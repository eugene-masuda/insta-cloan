require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Instagram "
  end
  
  test "should get root" do
    get root_path
    assert_response :success
  end
 
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | Instagram"
  end

  

end
