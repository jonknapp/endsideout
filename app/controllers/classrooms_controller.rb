class ClassroomsController < AdminController
  before_action :set_classroom, only: %i[ edit update ]

  # GET /classrooms/1/edit
  def edit
  end
  # PATCH/PUT /classrooms/1 or /classrooms/1.json
  def update
    respond_to do |format|
      if @classroom.update(classroom_params)
        format.html { redirect_to school_students_url(@classroom.school), notice: "Classroom was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @classroom }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @classroom.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classroom
      @classroom = Classroom.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def classroom_params
      params.expect(classroom: [ :name, :teacher ])
    end
end
