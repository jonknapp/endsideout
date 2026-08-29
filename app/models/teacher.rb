class Teacher < ApplicationRecord
  belongs_to :school
  has_many :classrooms, dependent: :nullify
  validates :name, presence: true
  validates :email, uniqueness: { scope: :school_id }, allow_blank: true
end
