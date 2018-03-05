require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def setup
    @user = Person.new(handlename: "test user", sex: 0, syear: 2, bplace: "Akita", name: "test honmyo",
                       email: "user@example.com", tel: "000-1234-5678",
                       password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "handlename should be present" do
    @user.handlename = "     "
    assert_not @user.valid?
  end

  test "sex should be present" do
    @user.sex = nil
    assert_not @user.valid?
  end

  test "syear should be present" do
    @user.syear = nil
    assert_not @user.valid?
  end

  test "bplace should be present" do
    @user.bplace = "     "
    assert_not @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "tel should be present" do
    @user.tel = "     "
    assert_not @user.valid?
  end

  test "handlename should not be too long" do
    @user.handlename = "a" * 51
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_person = @user.dup
    duplicate_person.email = @user.email.upcase
    @user.save
    assert_not duplicate_person.valid?
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

  test "should create and break relationship " do
    michael = people(:michael)
    archer  = people(:archer)
    assert_not michael.involved?(archer)
    michael.relation(archer)
  #  assert_not archer.involved1?(michael)
  end

end
