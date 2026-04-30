class CreateStudentSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :student_sessions do |t|
      t.belongs_to :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
