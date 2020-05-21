require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:messi)
  end

  # パスワード再設定
  test "password resets" do
    log_in_as(@user)
    get edit_password_reset_path(@user)
    assert_template 'password_resets/edit'
    assert @user.authenticate("password")
    # 現在のパスワードが一致しない
    patch password_reset_path,
          params: { user: { password_now: "wrong password",
                            password:              "hogehoge",
                            password_confirmation: "hogehoge" } }
    assert_select 'div.alert-danger'
    # パスワードが空
    patch password_reset_path,
          params: { user: { password_now: "password",
                            password:              "",
                            password_confirmation: "" } }
    assert_select 'div.alert-danger'
    # 新しいパスワードの組み合わせが異なる
    patch password_reset_path,
          params: { user: { password_now: "password",
                            password:              "foobar",
                            password_confirmation: "hogehoge" } }
    assert_select 'div.alert-danger'
    # 有効なパスワードとパスワード確認
    patch password_reset_path,
          params: { user: { password_now: "password",
                            password:              "hogehoge",
                            password_confirmation: "hogehoge" } }
    assert_not @user.reload.authenticate("password")
    assert     @user.reload.authenticate("hogehoge")
    assert_not flash.empty?
    assert_template 'password_resets/edit'
  end
end
