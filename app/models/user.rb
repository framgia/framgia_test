class User < ActiveRecord::Base
  self.table_name = 'training_user'
  self.primary_key = 'user_id'

  has_many :answer_sheets, foreign_key: "user_id", class_name:  "AnswerSheet"

  before_save { self.email = email.downcase }
  before_create :create_remember_token, :default_active_values, :default_user_admin_values
  validates :full_name, presence: true, length: { maximum: 256 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def admin_user?
    self.user_admin == 1
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  def default_active_values
    self.active_flag ||= 1
  end

  def default_user_admin_values
    self.user_admin ||= 0
  end

  def admin_user
    redirect_to(root_url) unless current_user.user_admin == 1
  end

end