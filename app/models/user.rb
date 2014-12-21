class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: { fan: 0, player: 1, admin: 2 }

  validates :username, presence: true, uniqueness: true

  def self.players
    where(role: [1, 2])
  end

  def self.didnt_reply_to_event(event_id)
    ids = User.players.pluck(:id) - Reply.where(event_id: event_id).pluck(:user_id)
    User.where(id: ids)
  end

  # TODO: Workaround to migrate users from legacy app
  # Following: https://vesselinv.com/rails-devise-user-migration-legacy-apps/
  def valid_password?(password)
    if legacy_password?
      # Use Devise's secure_compare to avoid timing attacks
      return false unless Devise.secure_compare(self.encrypted_password,
                                                User.legacy_password(password))

      self.attributes = { password:               password,
                          password_confirmation:  password,
                          legacy_password:        false }

      self.save!
    end

    super password
  end

  # TODO: Workaround to migrate users from legacy app
  # Following: https://vesselinv.com/rails-devise-user-migration-legacy-apps/
  def self.legacy_password(password)
    Digest::MD5.hexdigest(password)
  end
end
