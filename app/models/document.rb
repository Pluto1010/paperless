require "net/http"
require "uri"

class Document < ActiveRecord::Base
  #has_attached_file :attachment, :styles => { :pdf_thumbnail => ["", :jpg] }
  has_attached_file :attachment, :styles => {
  	:small => [{ width: 425, height: 300 }, :jpg],
  	:large => [{ width: 2048, height: 1450 }, :jpg]
  }, :processors => [:pdf_thumbnail]
  validates_attachment_content_type :attachment, :content_type => /\Aapplication\/pdf\Z/

  after_commit :extract_text_from_pdf

  private

  def extract_text_from_pdf
    if new_record?
      return
    end

    dst = Tempfile.new(['akten_doc', '.pdf'])
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
