class ClassroomRostersController < ApplicationController
  allow_unauthenticated_access

  def show
    @classroom = Classroom.includes(:students).find_by!(uuid: params.expect(:uuid))
  end
end
