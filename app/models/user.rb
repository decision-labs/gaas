class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  before_create :generate_api_key

  private

  def generate_api_key
    begin
      self.api_key = SecureRandom.hex
    end while self.class.where(api_key: self.api_key).exists?
  end

end
