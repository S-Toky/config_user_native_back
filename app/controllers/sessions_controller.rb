class SessionsController < ApplicationController

  before_action :signed_in?, only: [:destroy]
  before_action :signed_out?, only: [:new, :create]

  def new
  end

  def create
    user_params = params.require(:user)
    @user = User.where(username: user_params[:username]).or(User.where(email: user_params[:email])).first
    if @user and @user.authenticate(user_params[:password])
      session[:auth] = {id: @user.id}
      redirect_to root_path
    else
      redirect_to new_session_path
    end
  end

  def destroy
    session.destroy
    redirect_to root_path
  end
end
