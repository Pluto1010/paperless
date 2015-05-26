class AddAttachmentToDocument < ActiveRecord::Migration
  def self.up
    add_attachment :documents, :attachment
  end

  def self.down
    remove_attachment :documents, :attachment
  end
end
