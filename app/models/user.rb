class User < ActiveRecord::Base
  self.table_name = 'training_user'
  self.primary_key = 'user_id'

  has_many :answer_sheets, foreign_key: "user_id", class_name:  "AnswerSheet"

  before_save { self.email = email.downcase }
  before_create :create_remember_token, :default_active_values
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

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  def default_active_values
    self.active_flag ||= 1
  end

end