class RemoveTeacherFromClassrooms < ActiveRecord::Migration[8.1]
  def change
    remove_column :classrooms, :teacher, :string
  end
end
