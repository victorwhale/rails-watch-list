class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.text :overview, null: false
      t.string :poster_url, limit: 500, null: false
      t.decimal :rating, precision: 3, scale: 1, null: false

      t.timestamps
    end
  end
end
