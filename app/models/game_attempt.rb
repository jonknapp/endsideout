class GameAttempt < ApplicationRecord
  belongs_to :student
  belongs_to :game

  validates :student_id, :game_id, presence: true

  before_validation :ensure_token, on: :create

  def ensure_token
    self.token ||= SecureRandom.hex(12)
  end

  def start!
    update(started_at: Time.current)
  end

  def started?
    started_at.present?
  end

  def finish!(outcome = "completed")
    update(finished_at: Time.current, outcome: outcome)
  end

  def finished?
    finished_at.present?
  end
end
