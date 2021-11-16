class PasswordsController < ApplicationController

  before_action :signed_out?
  # before_action :signed_in?

  def new
    
  end
  
  def create
    user_params = params.require(:user)
    @user = User.find_by_email(user_params[:email])
    if @user
      @user.regenerate_recover_password
      UserMailer.password(@user).deliver_now
      redirect_to new_session_path
    else
      redirect_to new_password_path
    end
  end
  
  def edit
    @user = User.find(params[:id])
    if @user.recover_password != params[:token]
      redirect_to new_password_path
    end
  end
  
  def update
    user_params = params.require(:user).permit(:password, :password_confirmation, :recover_password)
    @user = User.find(params[:id])
    if @user.recover_password === user_params[:recover_password]
      @user.assign_attributes(user_params)
      if @user.valid?
        @user.recover_password = nil
        @user.save
        # session[:auth] = @user.to_session
        redirect_to new_session_path
      else
        render 'edit'
      end
    else
      redirect_to new_password_path
    end
  end
  
end
