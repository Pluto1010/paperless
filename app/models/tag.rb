class Tag < ActiveRecord::Base
  has_and_belongs_to_many :documents, join_table: :document_has_tags
end
