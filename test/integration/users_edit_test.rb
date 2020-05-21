require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:messi)
  end

  # プロフィール編集失敗
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { full_name:  "",
                                              user_name:  "",
                                              email: "foo@invalid" } }
    assert_template 'users/edit'
  end
  
  # プロフィール編集成功 with フレンドリーフォワーディング
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    full_name    = "Foo Bar"
    user_name    = "FB"
    website      = "https://foobar.com"
    introduction = "hello world"
    email        = "foo@bar.com"
    phone_number = "010-1234-5678"
    sex          = "男性"
    patch user_path(@user), params: { user: { full_name:    full_name,
                                              user_name:    user_name,
                                              website:      website,
                                              introduction: introduction,
                                              email:        email,
                                              phone_number: phone_number,
                                              sex:          sex } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal full_name,    @user.full_name
    assert_equal user_name,    @user.user_name
    assert_equal website,      @user.website
    assert_equal introduction, @user.introduction
    assert_equal email,        @user.email
    assert_equal phone_number, @user.phone_number
    assert_equal sex,          @user.sex
  end
end
