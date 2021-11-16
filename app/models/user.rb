class User < ApplicationRecord

  attr_accessor :avatar_file

  has_secure_password
  has_secure_token :confirmation_token
  has_secure_token :recover_password

  after_create :welcome_send

  after_save :avatar_after_upload
  after_destroy :avatar_destroy
  before_save :avatar_before_upload

  validates :username, format: { with: /\A[a-zA-Z0-9_]{2,20}\z/, message: "de A à Z et 0 à 9" }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}, uniqueness: true

  validates :avatar_file, file: {ext: [:jpg, :png], message: 'tsy izy io '}

  def avatar_path
    File.join(
      Rails.public_path,
      self.class.name.downcase.pluralize,
      id.to_s,
      "#{self.username}.jpg"
    )
  end
  
  def avatar_url
    '/' + [
      self.class.name.downcase.pluralize,
      id.to_s,
      "#{self.username}.jpg"
    ].join('/')
  end

  def welcome_send
    UserMailer.welcome(self).deliver_now
  end
  
  private

  def avatar_after_upload
    path = avatar_path
    if avatar_file.respond_to? :path
      dir = File.dirname(path)
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      image = MiniMagick::Image.new(avatar_file.path) do |b|
        b.resize "150x150^"
        b.gravity 'Center'
        b.crop '150x150+0+0'
      end
      image.format "jpg"
      image.write path
    end
  end

  def avatar_before_upload
    if avatar_file.respond_to? :path
      self.avatar = true
    end
  end

  def avatar_destroy
    dir = File.dirname(avatar_path)
    FileUtils.rm_r(dir) if Dir.exist?(dir)
  end
  
end