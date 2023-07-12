class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :author_name
      t.string :author_surname

      t.timestamps
    end
  end
end
