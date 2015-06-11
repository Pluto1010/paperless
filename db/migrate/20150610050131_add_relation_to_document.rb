class AddRelationToDocument < ActiveRecord::Migration
  def change
    add_reference :documents, :tag, index: true
    add_foreign_key :documents, :tags
  end
end
