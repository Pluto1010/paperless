class AddUniqueIndexToDocumentHasTags < ActiveRecord::Migration
  def change
    add_index :document_has_tags, [:document_id, :tag_id], :unique => true
  end
end
