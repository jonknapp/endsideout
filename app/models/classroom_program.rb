class ClassroomProgram < ApplicationRecord
  belongs_to :classroom
  belongs_to :program
  has_many :classroom_modules, dependent: :destroy

  enum :level, { basic: "basic", moderate: "moderate", advanced: "advanced" }, validate: true

  validates :level, presence: true
  validate :level_unchanged_if_modules_scheduled, on: :update

  def generate_modules!
    current_cm_ids = program.content_modules.where(level: level).pluck(:id)
    classroom_modules.where.not(content_module_id: current_cm_ids).destroy_all
    current_cm_ids.each do |cm_id|
      classroom_modules.find_or_create_by!(content_module_id: cm_id)
    end
  end

  private

  def level_unchanged_if_modules_scheduled
    return unless level_changed?
    if classroom_modules.where.not(publish_on: nil).exists?
      errors.add(:level, "cannot be changed when modules have publish dates set")
    end
  end
end
