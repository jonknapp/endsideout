class ContentModulesController < AdminController
  before_action :set_content_module, only: %i[edit update destroy]

  def index
    @programs = Program.order(:name)
    @active_program = @programs.find { |p| p.id.to_s == params[:program_id] } || @programs.first
    @modules_by_level = @active_program
      .content_modules
      .includes(:links)
      .group_by(&:level)
  end

  def new
    @content_module = ContentModule.new
  end

  def create
    @content_module = ContentModule.new(content_module_params)

    if @content_module.save
      redirect_to content_modules_path, notice: "Module was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @content_module.update(content_module_params)
      redirect_to content_modules_path, notice: "Module was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @content_module.destroy
      redirect_to content_modules_path, notice: "Module was successfully deleted.", status: :see_other
    else
      redirect_to content_modules_path, alert: "Cannot delete a module that has been assigned to classrooms."
    end
  end

  private
    def set_content_module
      @content_module = ContentModule.find(params.expect(:id))
    end

    def content_module_params
      params.expect(content_module: [ :name, :program_id, :level, :position ])
    end
end
