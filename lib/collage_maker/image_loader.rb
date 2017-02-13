require 'flickr_fu'

class ImageLoader
  attr_accessor :image_names

  def initialize(image_names)
    self.image_names = image_names
  end

  def retrieve_images
    formated_image_names.map do |image_name|
      retrieve_image(image_name)
    end
  end

  private

  def formated_image_names
    if image_names.count > 10
      image_names[0..9]
    else
      image_names + Array.new(10 - image_names.count)
    end
  end

  def retrieve_image(image_name)
    if image_name
      image = query_image(image_name)
      image || retrieve_image(random_image_name)
    else
      retrieve_image(random_image_name)
    end
  end

  def query_image(image_name)
    flickr.photos.search(text: image_name, sort: 'interestingness-desc', per_page: 1).first
  end

  def flickr
    @flickr ||= Flickr.new(File.absolute_path('lib/collage_maker/flickr.yml'))
  end

  def random_image_name
    File.readlines("/usr/share/dict/words").sample.chomp
  end
end
