class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :color
      t.string :icon

      t.timestamps null: false
    end
  end
end
