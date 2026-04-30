module StudentSessionTestHelper
  def student_sign_in_as(student)
    Current.student_session = student.sessions.create!

    ActionDispatch::TestRequest.create.cookie_jar.tap do |cookie_jar|
      cookie_jar.signed[:student_session_id] = Current.student_session.id
      cookies["student_session_id"] = cookie_jar[:student_session_id]
    end
  end

  def student_sign_out
    Current.student_session&.destroy!
    cookies.delete("student_session_id")
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  include StudentSessionTestHelper
end
