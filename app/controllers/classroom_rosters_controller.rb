class ClassroomRostersController < ApplicationController
  include StudentAuthentication
  allow_unauthenticated_access
  def show
    @classroom = Classroom.includes(:students).find_by!(uuid: params.expect(:uuid))
  end
end
