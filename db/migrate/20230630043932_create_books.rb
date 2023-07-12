class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :book_name
      t.integer :author_id

      t.timestamps
    end
  end
end
