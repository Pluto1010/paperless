class AddAttachmentProcessingToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :attachment_processing, :boolean
  end

  def self.down
    remove_column :documents, :attachment_processing
  end
end
