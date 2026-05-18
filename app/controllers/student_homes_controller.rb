class StudentHomesController < ApplicationController
  include StudentAuthentication

  def index
    @student = Current.student
    classroom = @student.classroom
    @classroom_programs = classroom.classroom_programs
      .includes(:program)
      .order("programs.name")
    @active_program = @classroom_programs.find { |cp| cp.id.to_s == params[:classroom_program_id] } || @classroom_programs.first
    @published_modules = if @active_program
      @active_program.classroom_modules.published.includes(content_module: :links)
    else
      []
    end
  end
end
