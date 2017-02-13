require 'spec_helper'
require File.expand_path('lib/collage_maker/image_processor')
require 'byebug'

RSpec.describe ImageProcessor do
  let(:image_path) { File.expand_path('spec/fixtures/test_image.png') }
  let(:flickr_image) { instance_double('Flickr::Photos::Photo') }
  let(:flickr_image_url) { 'www.flickr.image.com' }
  let(:minimagick_image) { MiniMagick::Image.open(image_path) }

  describe '#process_images' do
    before do
      minimagick_image.resize "600x400"
      expect(flickr_image).to receive(:image_url).and_return(flickr_image_url)
      expect(MiniMagick::Image).to receive(:open).with(flickr_image_url).and_return(minimagick_image)
    end

    it 'crops image properly' do
      croped_minimagick_image = subject.process_images([flickr_image]).first
      expect([croped_minimagick_image.width, croped_minimagick_image.height]).to eq([300, 200])
    end
  end

  describe '#compose_collage' do
    let(:collage_path) { File.expand_path('spec/fixtures/test_blank_collage.png') }
    let(:collage) { MiniMagick::Image.new(collage_path) }

    before do
      expect(subject).to receive(:create_blank_collage).and_return(collage)
    end

    it 'adds images inside collage' do
      collage = subject.compose_collage([minimagick_image, minimagick_image])
      expect([collage.width, collage.height]).to eq([60, 100])
    end
  end
end
