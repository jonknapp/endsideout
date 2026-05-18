class ClassroomModulesController < AdminController
  before_action :set_classroom_module

  def update
    if @classroom_module.update(classroom_module_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to schedule_classroom_url(@classroom_module.classroom_program.classroom) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(@classroom_module),
            partial: "classroom_modules/row",
            locals: { classroom_module: @classroom_module }
          ), status: :unprocessable_entity
        end
        format.html { redirect_to schedule_classroom_url(@classroom_module.classroom_program.classroom) }
      end
    end
  end

  private

  def set_classroom_module
    @classroom_module = ClassroomModule.find(params[:id])
  end

  def classroom_module_params
    params.expect(classroom_module: [ :publish_on ])
  end
end
