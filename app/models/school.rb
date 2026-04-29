class School < ApplicationRecord
  has_many :students, dependent: :destroy
  validates :name, presence: true
end
