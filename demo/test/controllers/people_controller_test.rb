require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = people(:michael)
    @other_user = people(:archer)
  end

  test "should get new" do
    get signup_1_path
    assert_response :success
  end

 test "should redirect index when not logged in" do
    get people_path
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get edit_person_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch person_path(@user), params: { person: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong person" do
    log_in_as(@other_user)
    get edit_person_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong person" do
    log_in_as(@other_user)
    patch person_path(@user), params: { person: {   handlename: @user.handlename,
                                                    sex: @user.sex,
                                                    syear: @user.syear,
                                                    bplace: @user.bplace,
                                                    name: @user.name,
                                                    email: @user.email,
                                                    tel: @user.tel} }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch person_path(@other_user), params: {
            person: { password:              @other_user.password,
                    password_confirmation: @other_user.password,
                    admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Person.count' do
      delete person_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'Person.count' do
      delete person_path(@user)
    end
    assert_redirected_to root_url
  end

end
