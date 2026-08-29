module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :current_student

    def connect
      if set_current_user
        Rails.logger.debug("[ActionCable] connected as user=#{current_user.id}")
      elsif set_current_student
        Rails.logger.debug("[ActionCable] connected as student=#{current_student.id}")
      else
        Rails.logger.debug("[ActionCable] connected anonymously")
      end
    end

    private

      def set_current_user
        if (session = Session.find_by(id: cookies.signed[:session_id]))
          self.current_user = session.user
        end
      end

      def set_current_student
        if (student_session = StudentSession.find_by(id: cookies.signed[:student_session_id]))
          Current.student_session = student_session
          self.current_student = student_session.student
        end
      end
  end
end
