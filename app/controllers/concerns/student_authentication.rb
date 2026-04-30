module StudentAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :require_student_authentication
    helper_method :student_authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_student_authentication, **options
    end
  end

  private
    def student_authenticated?
      resume_student_session
    end

    def require_student_authentication
      resume_student_session || request_student_authentication
    end

    def resume_student_session
      Current.student_session ||= find_student_session_by_cookie
    end

    def find_student_session_by_cookie
      StudentSession.find_by(id: cookies.signed[:student_session_id]) if cookies.signed[:student_session_id]
    end

    def request_student_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_student_session_path
    end

    def after_student_authentication_url
      session.delete(:return_to_after_authenticating) || student_homes_url
    end

    def start_new_student_session_for(student)
      student.sessions.create!.tap do |session|
        Current.student_session = session
        cookies.signed.permanent[:student_session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    def terminate_student_session
      Current.student_session.destroy
      cookies.delete(:student_session_id)
    end
end
