class StudentSessionsController < ApplicationController
  include StudentAuthentication
  allow_unauthenticated_access only: %i[ create new ]
  before_action :set_student, only: %i[ create ]

  def new
  end

  def create
    if @student
      start_new_student_session_for(@student)
      redirect_to after_student_authentication_url
    else
      redirect_to new_student_session_path, alert: "Invalid classroom or student ID."
    end
  end

  def destroy
    terminate_student_session
    redirect_to new_student_session_path, status: :see_other
  end

  private

  def set_student
    classroom = Classroom.find_by(uuid: params.expect(:classroom_uuid))
    return unless classroom
    @student = classroom.students.find_by(id: params.expect(:student_id))
  end
end
