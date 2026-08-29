class Students::BaseController < ApplicationController
  include StudentAuthentication

  before_action :set_event_context

  private

  def set_event_context
    Rails.event.set_context(student_id: Current.student_session.student_id)
  end
end
