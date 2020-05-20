require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Instagram "
  end
  
  test "should get root" do
    get root_path
    assert_response :success
    assert_select "title", "Instagram"
  end
 


  

end
