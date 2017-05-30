# encoding: utf-8

class ContentMediaUploader < CarrierWave::Uploader::Base
  if defined?(Cloudinary)
    include Cloudinary::CarrierWave
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
