class Notifier < ActionMailer::Base
  

  def password_reset_instructions(user, sent_time = Time.now)
    setup_email_defaults(:subject => "Password reset instructions")
    recipients    user.email
    sent_on       sent_time
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
  def invitation_notification(invitation)
    setup_email_defaults(:subject => "Notification request")
    body          :email => invitation.email
    recipients    "HyeWye Notifications <notifications@hyewye.com>"
  end
  
  private
    def setup_email_defaults(options={})
      subject       "[HyeWye] #{options[:subject]}"
      from          "notifier@hyewye.com"
    end

end
