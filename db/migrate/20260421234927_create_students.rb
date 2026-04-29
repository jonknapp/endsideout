class CreateStudents < ActiveRecord::Migration[8.1]
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.integer :grade_level, null: false
      t.string :gender
      t.belongs_to :school, null: false, foreign_key: true

      t.timestamps
    end
  end
end
