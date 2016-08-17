class Player < ApplicationRecord
  include FriendlyId

  mount_uploader :avatar, AvatarUploader unless Rails.env.test?

  delegate :street, :zipcode, :city, to: :address
  delegate :address, to: :user
  delegate :contact, to: :user

  belongs_to :user
  has_many :attendances, dependent: :destroy

  validates :nickname, presence: true
  validates :jersey_number, uniqueness: true, allow_nil: true
  validates :user_id, uniqueness: true, presence: true

  enum status: { active: 0, injured: 1, inactive: 2 }

  friendly_id :nickname, use: :slugged

  paginates_per 12

  scope :player_pass, -> (needed) { where(player_pass: true) if needed }

  def club_email_with_nickname
    %("#{nickname}" <#{club_email}>)
  end
end
