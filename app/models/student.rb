class Student < ApplicationRecord
  belongs_to :school
  belongs_to :classroom

  enum :gender, %i[male female other].index_by(&:itself)

  validates :first_name, :last_name, :grade_level, presence: true

  def full_name = [ first_name, last_name ].join(" ")
end
