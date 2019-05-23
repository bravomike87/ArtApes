class Artwork < ApplicationRecord
  belongs_to :user
  has_many :bookings
  mount_uploader :image, PhotoUploader
  validates :title, presence: true
  validates :description, presence: true
  validates :kind, presence: true
  validates :price, presence: true
  validates :tagline, presence: true, length: { minimum: 4 }
end
