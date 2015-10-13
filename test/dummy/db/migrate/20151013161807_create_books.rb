class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.text :name
      t.text :description

      t.timestamps null: false
    end
  end
end
