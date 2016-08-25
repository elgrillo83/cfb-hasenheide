class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :addresses, as: :addressable

  scope :club, -> { where(club: true).order('name') }
  scope :rivals, -> { where(club: false).order('name') }
  scope :current_season, lambda { |boolean|
    where(current_season: boolean).order('name')
  }
end
