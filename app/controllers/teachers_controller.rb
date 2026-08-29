class TeachersController < AdminController
  before_action :set_school, only: %i[index new create]
  before_action :set_teacher, only: %i[show edit update destroy]

  def index
    @teachers = @school.teachers
  end

  def show
  end

  def new
    @teacher = @school.teachers.build
    @classrooms = @school.classrooms
  end

  def edit
    @school = @teacher.school
    @classrooms = @school.classrooms
  end

  def create
    @teacher = @school.teachers.build(teacher_params)
    @classrooms = @school.classrooms
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to @teacher, notice: "Teacher was successfully created." }
        format.json { render :show, status: :created, location: @teacher }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @school = @teacher.school
    @classrooms = @school.classrooms

    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to @teacher, notice: "Teacher was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @teacher.destroy!

    respond_to do |format|
      format.html { redirect_to school_teachers_url(@teacher.school), notice: "Teacher was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_teacher
    @teacher = Teacher.find(params.expect(:id))
  end

  def set_school
    @school = School.find(params.expect(:school_id))
  end

def teacher_params
  params.expect(teacher: [ :name, :email, { classroom_ids: [] } ])
end
end
