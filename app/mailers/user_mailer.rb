class UserMailer < ActionMailer::Base
  default from: "support@BitcoinNow.com"

  def verification_email(user)
    @user = user
    @url = "http://192.168.1.6:3000/users/#{@user.id}/verify/#{@user.verification_code}"
    mail(to: @user.email, subject: 'Verify your email with BitcoinNow')
  end
    
end
