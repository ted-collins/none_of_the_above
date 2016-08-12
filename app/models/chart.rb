class Chart < ActiveRecord::Base

  attr_accessor :content_type, :original_filename, :image_data
  before_save :decode_base64_image

  has_attached_file :static_image, :styles => { :thumb => '32x32#', :medium => '64x64#', :large => '256x256#', :original => '400x300#' }, default_url: "/images/:style/missing.png"
  validates_attachment_file_name :static_image, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]

  protected
    def decode_base64_image
      if image_data && content_type && original_filename
        decoded_data = Base64.decode64(image_data)
		logger.debug("Decoded Image #{decoded_data}")

        data = StringIO.new(decoded_data)
        data.class_eval do
          attr_accessor :content_type, :original_filename
        end

        data.content_type = content_type
		logger.debug("Content Type #{data.content_type}")
        data.original_filename = File.basename(original_filename)
		logger.debug("Original Filename #{data.original_filename}")

        self.static_image = data
      end
	end
end
