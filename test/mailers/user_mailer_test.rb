require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "request_notification" do
    mail = UserMailer.request_notification
    assert_equal "Request notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
