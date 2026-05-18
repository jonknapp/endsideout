class CreateClassroomModules < ActiveRecord::Migration[8.1]
  def change
    create_table :classroom_modules do |t|
      t.references :classroom_program, null: false, foreign_key: true
      t.references :content_module, null: false, foreign_key: true
      t.date :publish_on

      t.timestamps
    end

    add_index :classroom_modules, [ :classroom_program_id, :content_module_id ], unique: true,
      name: "index_classroom_modules_on_classroom_program_and_content_module"
  end
end
