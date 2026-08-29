class Game < ApplicationRecord
  belongs_to :content_module, optional: true

  has_many :game_attempts, dependent: :destroy

  validates :title, :slug, presence: true
  validates :title, :slug, uniqueness: true
end
