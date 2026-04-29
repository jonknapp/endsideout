class CreateClassrooms < ActiveRecord::Migration[8.1]
  def change
    create_table :classrooms do |t|
      t.string :name
      t.belongs_to :school, null: false, foreign_key: true
      t.string :teacher
      t.string :uuid, null: false, index: { unique: true }

      t.timestamps
    end

    change_table :students do |t|
      t.belongs_to :classroom, null: false, foreign_key: true
    end
  end
end
