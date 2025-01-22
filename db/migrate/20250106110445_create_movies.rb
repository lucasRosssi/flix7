class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :name
      t.string :rating
      t.decimal :total_gross

      t.timestamps
    end
  end
end
