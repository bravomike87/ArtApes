class Profile < ApplicationRecord
  belongs_to :user
  mount_uploader :avatar, PhotoUploader
  validates :first_name, presence: true, allow_nil: true
  validates :last_name, presence: true, allow_nil: true
  validates :address, presence: true, allow_nil: true
end
