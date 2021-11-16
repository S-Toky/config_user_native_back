class UserMailer < ApplicationMailer
  default from: "notification@example.com"

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "vous êtes inscrit sur le site" )
  end

  def password(user)
    @user = user
    mail(to: @user.email, subject: "récupération de votre mot de passe" )
  end

end