class LegalServicesFileUploader < CarrierWave::Uploader::Base
  storage Rails.env.production? ? :aws : :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "legal_services/data/#{mounted_as}/#{model.id}"
  end

  def size_range
    1..10.megabytes
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[xls xlsx json]
  end

  def cache_dir
    Rails.root.join('storage', 'legal_services', 'tmp', 'uploads')
  end
end
