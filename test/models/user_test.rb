require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "requires email address" do
    user = User.new(password: "password")

    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "database rejects duplicate email addresses" do
    assert_raises ActiveRecord::RecordNotUnique do
      User.insert!({
        email_address: users(:one).email_address,
        password_digest: users(:one).password_digest,
        created_at: Time.current,
        updated_at: Time.current
      })
    end
  end
end
