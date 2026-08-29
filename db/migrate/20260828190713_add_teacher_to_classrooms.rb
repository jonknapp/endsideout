class AddTeacherToClassrooms < ActiveRecord::Migration[8.1]
  def change
    add_reference :classrooms, :teacher, null: true, foreign_key: true
  end
end
