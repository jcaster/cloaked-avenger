class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    @user.verified = false
    @user.verification_code = ('a'..'z').to_a.shuffle[0,15].join
    if @user.save
      UserMailer.verification_email(@user).deliver!
      sign_in @user
      flash[:success] = "Welcome to BitcoinNow!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def verify
    @user = User.find(params[:id])
    if (@user.verified)
       flash[:success] = "Your account has already been verified."
       redirect_to root_path
       return
    end
    if (@user.verification_code == params[:vcode])
      @user.verified = true
      if @user.save!
        flash[:success] = "Thank you for verifying your account."
      end
      redirect_to @user
    else
        flash[:error] = "Unfortunately, the email verification did not succeed.  Please contact support if you need further assistance."
        redirect_to root_path
    end 
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
