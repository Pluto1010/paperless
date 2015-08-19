@documents.each do |actual_month, documents_per_month|
  json.set!(actual_month, documents_per_month) do |document|
    json.extract! document, :id, :created_at, :updated_at, :received_at
    json.url document_path(document, format: :json)
    json.paper do
      json.preview document.attachment.url(:small)
      json.original document.attachment.url(:original)
    end
  end
end
