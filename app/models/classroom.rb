class Classroom < ApplicationRecord
  belongs_to :teacher, optional: true
  belongs_to :school
  has_many :students
  has_many :classroom_programs, dependent: :destroy
  has_many :programs, through: :classroom_programs

  accepts_nested_attributes_for :classroom_programs,
    allow_destroy: true,
    reject_if: proc { |attrs| attrs["id"].blank? && attrs["_destroy"] == "1" }

  validate :at_least_one_active_program, on: :update
  before_validation :ensure_uuid, on: :create
  validate :teacher_belongs_to_same_school

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.urlsafe_base64(32)
  end

  def at_least_one_active_program
    active = classroom_programs.reject(&:marked_for_destruction?)
    errors.add(:base, "must have at least one program enrolled") if active.empty?
  end

  def teacher_belongs_to_same_school
    return if teacher.blank?
    return if teacher.school_id == school_id

    errors.add(:teacher, "must belong to the same school")
  end
end
