require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(full_name: "lionel Messi",
                     user_name: "Example User",
                         email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  # 有効なユーザーである
  test "should be valid" do
    assert @user.valid?
  end
  
  test "full_name should be present" do
    @user.full_name = "     "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  test "full_name should not be too long" do
    @user.full_name = "a" * 51
    assert_not @user.valid?
  end
  
  test "user_name should not be too long" do
    @user.user_name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    messi = users(:messi)
    honda  = users(:honda)
    assert_not messi.following?(honda)
    messi.follow(honda)
    assert messi.following?(honda)
    assert honda.followers.include?(messi)
    messi.unfollow(honda)
    assert_not messi.following?(honda)
  end
  
  test "feed should have the right posts" do
    messi = users(:messi)
    honda  = users(:honda)
    ronald    = users(:ronald)
    # フォローしているユーザーの投稿を確認
    ronald.microposts.each do |post_following|
      assert messi.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    messi.microposts.each do |post_self|
      assert messi.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    honda.microposts.each do |post_unfollowed|
      assert_not messi.feed.include?(post_unfollowed)
    end
  end
end
