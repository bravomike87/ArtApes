class Profile < ApplicationRecord
  belongs_to :user

  mount_uploader :avatar, PhotoUploader

  geocoded_by :address

  validates :first_name, presence: true, allow_nil: true
  validates :last_name, presence: true, allow_nil: true
  validates :address, presence: true, allow_nil: true

  after_validation :geocode, if: :will_save_change_to_address?
end
