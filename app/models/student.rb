class Student < ApplicationRecord
  belongs_to :school

  enum :gender, %i[male female other].index_by(&:itself)

  validates :first_name, :last_name, :grade_level, presence: true
end
