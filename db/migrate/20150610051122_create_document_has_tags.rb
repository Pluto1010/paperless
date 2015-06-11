class CreateDocumentHasTags < ActiveRecord::Migration
  def change
    create_table :document_has_tags do |t|
       t.belongs_to :document, null: false
       t.belongs_to :tag, null: false
       t.timestamps
    end
  end
end
