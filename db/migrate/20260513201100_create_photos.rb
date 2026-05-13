class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.integer :pexels_id, null: false
      t.integer :width, null: false
      t.integer :height, null: false
      t.string :url, null: false
      t.string :photographer, null: false
      t.string :photographer_url, null: false
      t.integer :photographer_id, null: false
      t.string :avg_color, null: false
      t.text :alt, null: false
      t.integer :likes_count, null: false, default: 0
      t.integer :comments_count, null: false, default: 0

      t.timestamps
    end

    add_index :photos, :pexels_id, unique: true
  end
end
