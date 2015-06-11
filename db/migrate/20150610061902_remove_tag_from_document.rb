class RemoveTagFromDocument < ActiveRecord::Migration
  def change
    remove_reference(:documents, :tag, index: true)
  end
end
