class Document < ActiveRecord::Base
  #has_attached_file :attachment, :styles => { :pdf_thumbnail => ["", :jpg] }
  has_attached_file :attachment, :styles => {
  	:small => [{ width: 425, height: 300 }, :jpg],
  	:large => [{ width: 2048, height: 1450 }, :jpg]
  }, :processors => [:pdf_thumbnail]
  validates_attachment_content_type :attachment, :content_type => /\Aapplication\/pdf\Z/
end
