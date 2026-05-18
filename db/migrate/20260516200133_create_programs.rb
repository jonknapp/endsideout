class CreatePrograms < ActiveRecord::Migration[8.1]
  def change
    create_table :programs do |t|
      t.string :name

      t.timestamps
    end

    create_table :classroom_programs do |t|
      t.references :classroom, null: false, foreign_key: true
      t.references :program, null: false, foreign_key: true
      t.string :level, null: false

      t.timestamps
    end

    add_index :classroom_programs, [ :classroom_id, :program_id ], unique: true
  end
end
