require "net/http"
require "uri"
require 'elasticsearch/model'

class Document < ActiveRecord::Base
  include Searchable

  has_and_belongs_to_many :tags, join_table: :document_has_tags

  has_attached_file :attachment, :styles => {
  	:small => [{ width: 425, height: 600 }, :jpg],
  	:large => [{ width: 1024, height: 1450 }, :jpg]
  }, :processors => [:pdf_thumbnail]
  validates_attachment_content_type :attachment, :content_type => /\Aapplication\/pdf\Z/

  #after_commit :extract_text_from_pdf

  scope :by_received_date, -> { order('received_at ASC, id DESC') }

  def self.filter_by_tag_ids(tag_ids)
    document_ids = nil;

    for tag_id in tag_ids
      next_document_ids = joins(:tags).where('tags.id = ?', tag_id).pluck(:id)

      if document_ids.nil?
        document_ids = next_document_ids
        next
      end

      document_ids = document_ids & next_document_ids
    end

    find(document_ids)
  end

  private

  def extract_text_from_pdf
    if new_record?
      return
    end

    dst = Tempfile.new(['paperless_doc', '.pdf'])
    dst.binmode

    begin
      attachment.copy_to_local_file :original, dst

      self.text = send_tika_request dst

      self.update_column(:text, self.text)

    ensure
      dst.close unless dst.nil?
    end
  end

  def send_tika_request(document)
    headers = {
      "Content-Type" => 'application/pdf',
      "Content-Length" => File.size(document),
      "Accept-Charset" => 'utf-8'
    }

    response = http_put 'http://192.168.33.31:9998/tika', headers, document.read
    response.body.force_encoding("utf-8")
  end

  def http_put(url, headers = {}, body = "")
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.request_uri)
    headers.keys.each do |key|
      request[key] = headers[key]
    end
    request.body = body
    http.request(request)
  end
end
