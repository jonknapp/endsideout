class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.references :content_module, foreign_key: true
      t.text :description

      t.index :slug, unique: true
      t.timestamps
    end
  end
end
