class StudentHomesController < ApplicationController
  include StudentAuthentication

  def index
    @student = Current.student
  end
end
