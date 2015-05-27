module Paperclip
  class PdfThumbnail < Processor

    def initialize(file, options = {}, attachment = nil)
      super
      @file = file
      @instance = options[:instance]
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
    end

    def make
      dst = Tempfile.new([@basename, 'jpg'].compact.join("."))
      dst.binmode

      # load PDF
      pdf = ::Magick::ImageList.new File.expand_path(@file.path) do
        self.format = 'PDF'
        self.quality = 75
        self.density = 200
      end

      # load first and second page and put them together. horizontal
      image = pdf[0..1].append(false)

      # correct
      image.trim!
      #image = image.sharpen

      # resize
      geometry = @options[:geometry]
      image.resize_to_fit! geometry[:width], geometry[:height]

      image.background_color = "lightgrey"
      image.gravity = Magick::CenterGravity
      image = image.extent geometry[:width], geometry[:height]

      # write out
      image.format = 'JPG'
      image.write(File.expand_path(dst.path))

      dst.flush
      return dst
    end
  end
end
