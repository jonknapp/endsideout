class ClassroomModule < ApplicationRecord
  belongs_to :classroom_program
  belongs_to :content_module

  scope :published, -> { where.not(publish_on: nil).where("publish_on <= ?", Date.current) }
end
