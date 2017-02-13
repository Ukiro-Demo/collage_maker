require File.expand_path('lib/collage_maker/image_loader')
require File.expand_path('lib/collage_maker/image_processor')

class CollageMaker
  def run(*image_names)
    flickr_images = ImageLoader.new(image_names).retrieve_images
    processed_minimagick_images = image_processor.process_images(flickr_images)
    collage = image_processor.compose_collage(processed_minimagick_images)
    save_to_file(collage)
  end

  def comand_line_run
    run(*ARGV)
  end

  private

  def image_processor
    @image_processor ||= ImageProcessor.new
  end

  def save_to_file(collage)
    puts "Please enter file name to save collage:"
    filename = $stdin.gets.chomp
    filename = 'collage.png' if filename.empty?
    collage.write filename
  end
end

# Uncomment in order to run the collage maker from command line:
# CollageMaker.new.comand_line_run
