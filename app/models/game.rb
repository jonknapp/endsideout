class Game < ApplicationRecord
  belongs_to :content_module, optional: true

  validates :title, :slug, presence: true
  validates :title, :slug, uniqueness: true
end
