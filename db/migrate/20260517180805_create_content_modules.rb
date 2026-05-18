class CreateContentModules < ActiveRecord::Migration[8.1]
  def change
    create_table :content_modules do |t|
      t.references :program, null: false, foreign_key: true
      t.string :level, null: false
      t.string :name, null: false
      t.integer :position

      t.timestamps
    end
  end
end
