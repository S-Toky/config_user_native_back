class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?

  private

  def signed_in?
    if !current_user
      redirect_to new_user_path
    end
  end

  def signed_out?
    redirect_to root_path if user_signed_in?
  end
  

  def user_signed_in?
    !current_user.nil?
  end
  

  def current_user
    return nil if !session[:auth] || !session[:auth]['id']
      return @_user if @_user
      @_user = User.find_by_id(session[:auth]['id'])
  end
  
end
