class Event < ActiveRecord::Base
  has_many   :replies,    dependent: :destroy
  has_one    :report,     dependent: :destroy
  belongs_to :club_team,  class_name: 'Team'
  belongs_to :rival_team, class_name: 'Team'

  enum kind: { league: 0, cup: 1, tournament: 2, friendly: 3, other: 4 }

  validates :kind, :datetime, :club_team_id, presence: true

  validates :minimum,
    numericality: { greater_than: 0, less_than_or_equal_to: :maximum }
  validates :maximum, numericality: { less_than_or_equal_to: User.count }

  validates :home, inclusion: { in: [true, false] }
  validates :home, exclusion: { in: [nil] }

  validate :rival_team_id_or_name

  scope :upcoming, -> (limit = nil) { where('datetime >= ?', Time.now).order('datetime ASC').limit(limit) }
  scope :past,     -> (limit = nil) { where('datetime < ?', Time.now).order('datetime DESC').limit(limit) }

  paginates_per 15

  def self.without_report
    ids = Report.all.pluck(:event_id)
    where.not(id: ids)
  end

  def upcoming?
    datetime >= Time.now
  end

  def past?
    datetime < Time.now
  end

  def yes_count
    replies.yes.count
  end

  def waiting_count
    replies.waiting.count
  end

  def google_maps_url
    "http://maps.google.com/?q=#{address}"
  end

  def google_static_maps_url
    'http://maps.googleapis.com/maps/api/staticmap' \
    "?center=#{address}" \
    "&markers=color:green|#{address}" \
    '&zoom=14' \
    '&size=400x400' \
    '&sensor=false' \
    '&scale=2'
  end

  def generated_name
    return name if name.present?
    if home?
      club_team.name + ' : ' + rival_team.name
    else
      rival_team.name + ' : ' + club_team.name
    end
  end

  def won?
    return false unless report.present? && report.final_score_present?
    report.club_final_score > report.rival_final_score
  end

  def lost?
    return false unless report.present? && report.final_score_present?
    report.club_final_score < report.rival_final_score
  end

  def drawed?
    return false unless report.present? && report.final_score_present?
    report.club_final_score == report.rival_final_score
  end

  def open!
    return if replyable?

    ActiveRecord::Base.transaction do
      User.pending_players_for_event(id).pluck(:id).each do |user_id|
        Reply.create!(user_id: user_id, event_id: id, status: :pending)
      end

      update!(replyable: true)
    end
  end

  def close!
    return unless replyable?

    ActiveRecord::Base.transaction do
      Reply.event(id).pending.delete_all

      update!(replyable: false)
    end
  end

  private

  def rival_team_id_or_name
    if !(rival_team.present? || name.present?)
      errors.add(:rival_team_id, 'muss ausgefüllt werden (oder Name)')
      errors.add(:name, 'muss ausgefüllt werden (oder Gegnermannschaft)')
    end
  end
end
