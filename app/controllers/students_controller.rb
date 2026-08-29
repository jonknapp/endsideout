class StudentsController < AdminController
  before_action :set_school, only: %i[ index new create ]
  before_action :set_student, only: %i[ edit update destroy ]

  # GET /students or /students.json
  def index
    @students = @school.students.includes(:classroom).all
  end

  # GET /students/new
  def new
    @student = @school.students.build
  end

  # GET /students/1/edit
  def edit
    @classrooms = @student.school.classrooms.all
  end

  # POST /students or /students.json
  def create
    @student = @school.students.build(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to school_url(@student.school_id, tab: "students"), notice: "Student was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to school_url(@student.school_id, tab: "students"), notice: "Student was successfully updated.", status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to school_path(@student.school_id, tab: "students"), notice: "Student was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params.expect(:id))
    end

  def set_school
    @school = School.find(params.expect(:school_id))
  end

    # Only allow a list of trusted parameters through.
    def student_params
      params.expect(student: [ :first_name, :last_name, :email, :grade_level, :gender, :classroom_id ])
    end
end
