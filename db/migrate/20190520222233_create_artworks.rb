class CreateArtworks < ActiveRecord::Migration[5.2]
  def change
    create_table :artworks do |t|
      t.string :title
      t.text :description
      t.string :image
      t.string :type
      t.decimal :price
      t.integer :width
      t.integer :height
      t.string :tagline
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
