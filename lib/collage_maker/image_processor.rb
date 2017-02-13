require 'mini_magick'
require 'tempfile'

class ImageProcessor
  attr_reader :config

  Config = Struct.new(:width, :height)

  def initialize
    @config = Config.new(300, 200)
  end

  def process_images(images)
    images.map do |image|
      MiniMagick::Image.open(image.image_url).tap do |mm_image|
        crop_x = (mm_image.width - config.width)/2
        crop_y = (mm_image.height - config.height)/2
        mm_image.crop("#{config.width}x#{config.height}+#{crop_x}+#{crop_y}")
        mm_image.format 'png'
      end
    end
  end

  def compose_collage(images)
    collage = create_blank_collage
    images.each_slice(2).with_index do |(first_image, second_image), pair_number|
      collage = collage.composite(first_image) do |c|
        c.compose 'Over'
        c.geometry "+0+#{config.height * pair_number}"
      end
      collage = collage.composite(second_image) do |c|
        c.compose 'Over'
        c.geometry "+#{config.width}+#{config.height * pair_number}"
      end
    end
    collage
  end

  private

  def create_blank_collage
    tmp = Tempfile.new(['mini_magick_', '.png'])
    `convert -size #{config.width*2}x#{config.height*5} xc:transparent #{tmp.path}`
    MiniMagick::Image.new(tmp.path, tmp)
  end
end
