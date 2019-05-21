class User < ApplicationRecord
  has_one :profile
  # has_many :artworks
  # has_many :bookings
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_profile

  def create_profile
    @user = User.last
    @profile = Profile.new
    @user.profile = @profile
    @user.save
    @profile.save
  end
  
end
