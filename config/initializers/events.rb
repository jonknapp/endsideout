class LogSubscriber
  def emit(event)
    context = event[:context].map { |key, value| "#{key}=#{value}" }.join(" ")
    payload = event[:payload].map { |key, value| "#{key}=#{value}" }.join(" ")
    source_location = event[:source_location]
    log = "[#{event[:name]}] (#{context}) #{payload} at #{source_location[:filepath]}:#{source_location[:lineno]}"
    Rails.logger.info(log)
  end
end

class StudentActivitySubscriber
  include ActionView::RecordIdentifier

  def emit(event)
    return unless event[:name] == "student.view_link"

    Rails.logger.debug("[StudentActivitySubscriber] event received: #{event[:name]}")

    student_id = event[:context][:student_id]
    link_id = event[:payload][:link_id]
    Rails.logger.debug("[StudentActivitySubscriber] student_id=#{student_id} link_id=#{link_id}")

    student = Student.find_by(id: student_id)
    link = Link.find_by(id: link_id)
    Rails.logger.debug("[StudentActivitySubscriber] student=#{student&.id.inspect} link=#{link&.id.inspect}")
    return unless student && link

    occurred_at = Time.current
    stream = dom_id(student)
    Rails.logger.debug("[StudentActivitySubscriber] stream=#{stream}")

    Rails.logger.debug("[StudentActivitySubscriber] broadcasting replace to #{stream}##{dom_id(student, :last_activity)}")
    Turbo::StreamsChannel.broadcast_replace_to(
      stream,
      target: dom_id(student, :last_activity),
      html: last_activity_html(student, link, occurred_at)
    )
    Rails.logger.debug("[StudentActivitySubscriber] replace broadcast complete")
  rescue => e
    Rails.logger.error("[StudentActivitySubscriber] ERROR: #{e.class}: #{e.message}")
    Rails.logger.error(e.backtrace.first(5).join("\n"))
  end

  private

  def activity_item_html(link)
    <<~HTML
      <li id="link_#{link.id}_activity" class="flex items-center gap-2 text-sm py-1">
        <span class="badge badge-outline badge-sm capitalize">#{link.link_type}</span>
        <span class="opacity-70">#{ERB::Util.html_escape(link.title)}</span>
      </li>
    HTML
  end

  def last_activity_html(student, link, occurred_at)
    <<~HTML
      <span id="#{dom_id(student, :last_activity)}" class="text-sm font-normal opacity-70">
        <span class="badge badge-outline badge-sm capitalize">#{link.link_type}</span>
        #{ERB::Util.html_escape(link.title)} &middot; #{occurred_at.strftime("%-I:%M %p")}
      </span>
    HTML
  end
end

Rails.event.subscribe(LogSubscriber.new)
Rails.event.subscribe(StudentActivitySubscriber.new)
