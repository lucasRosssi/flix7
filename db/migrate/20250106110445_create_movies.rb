class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.string :name
      t.string :rating
      t.decimal :total_gross

      t.timestamps
    end
  end
end
