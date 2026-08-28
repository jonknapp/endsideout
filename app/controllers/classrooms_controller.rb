class ClassroomsController < AdminController
  before_action :set_school, only: %i[index new create]
  before_action :set_classroom, only: %i[edit update schedule]

  def index
    @classrooms = @school.classrooms
      .includes(:students, classroom_programs: :program)
      .order(:name)
  end

  def new
    @classroom = @school.classrooms.build
    build_missing_program_enrollments
  end

  def create
    @classroom = @school.classrooms.build(classroom_params)

    respond_to do |format|
      if @classroom.save
        @classroom.classroom_programs.reload.each(&:generate_modules!)
        format.html { redirect_to school_classrooms_url(@school), notice: "Classroom was successfully created.", status: :see_other }
        format.json { render json: @classroom, status: :created }
      else
        build_missing_program_enrollments
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    build_missing_program_enrollments
  end

  def schedule
    @classroom_programs = @classroom.classroom_programs
      .includes(:program, classroom_modules: :content_module)
      .order("programs.name")
    @active_enrollment = @classroom_programs.find { |cp| cp.id.to_s == params[:classroom_program_id] } || @classroom_programs.first
  end

  def update
    respond_to do |format|
      if @classroom.update(classroom_params)
        @classroom.classroom_programs.reload.each(&:generate_modules!)
        format.html { redirect_to school_students_url(@classroom.school), notice: "Classroom was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @classroom }
      else
        build_missing_program_enrollments
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_classroom
      @classroom = Classroom.find(params.expect(:id))
    end

    def set_school
      @school = School.find(params.expect(:school_id))
    end

    def build_missing_program_enrollments
      @classroom.classroom_programs.load unless @classroom.classroom_programs.loaded?
      enrolled_ids = @classroom.classroom_programs.target.map(&:program_id).to_set
      Program.order(:name).each do |program|
        @classroom.classroom_programs.build(program: program) unless enrolled_ids.include?(program.id)
      end
    end

    def classroom_params
      params.expect(classroom: [ :name, :teacher, classroom_programs_attributes: [ [ :id, :program_id, :level, :_destroy ] ] ])
    end
end
