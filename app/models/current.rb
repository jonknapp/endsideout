class Current < ActiveSupport::CurrentAttributes
  attribute :session, :student_session
  delegate :user, to: :session, allow_nil: true
  attribute :student_session
  delegate :student, to: :student_session, allow_nil: true
end
