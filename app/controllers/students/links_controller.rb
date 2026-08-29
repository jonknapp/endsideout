class Students::LinksController < Students::BaseController
  def show
    @link = accessible_links.find(params.expect(:id))
    Rails.event.notify("student.view_link", link_id: @link.id, link_type: @link.link_type)
  end

  private

  def accessible_links
    Link.joins(content_module: { classroom_modules: :classroom_program })
        .merge(ClassroomModule.published)
        .where(classroom_programs: { classroom_id: Current.student.classroom_id })
  end
end
