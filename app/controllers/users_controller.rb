class UsersController < ApplicationController

  before_action :signed_in?, only: [:edit]
  before_action :signed_out?, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
    @user = User.new(user_params)
    @user.recover_password = nil
    if @user.valid?
      @user.save
      session[:auth] = {id: @user.id}
      redirect_to profil_path
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    user_params = params.require(:user).permit(:firstname, :lastname, :username, :email, :avatar_file, :password, :password_confirmation)
    if @user.update(user_params)
      redirect_to profil_path
    else
      redirect_to profil_path
    end
  end
  
  
end