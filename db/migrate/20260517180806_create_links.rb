class CreateLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :links do |t|
      t.references :content_module, null: false, foreign_key: true
      t.string :title, null: false
      t.string :url, null: false
      t.string :link_type, null: false
      t.integer :position

      t.timestamps
    end
  end
end
