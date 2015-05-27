class AddTextToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :text, :text
  end
end
