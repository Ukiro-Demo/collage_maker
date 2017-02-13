require 'spec_helper'
require File.expand_path('lib/collage_maker/image_loader')

RSpec.describe ImageLoader do
  describe '#retrieve_images' do
    subject { ImageLoader.new([provided_name] * provided_names_count) }

    let(:provided_name) { 'provided image name' }
    let(:random_name) { 'random image name' }
    let(:image) { instance_double('Flickr::Photos::Photo') }

    context 'when less than 10 image names' do
      let(:provided_names_count) { 5 }

      before do
        expect(subject).to receive(:query_image).with(provided_name).and_return(:image).exactly(5).times
        expect(subject).to receive(:random_image_name).and_return(random_name).exactly(5).times
        expect(subject).to receive(:query_image).with(random_name).and_return(:image).exactly(5).times
      end

      it 'returns 10 images' do
        expect(subject.retrieve_images.count).to eq(10)
      end
    end

    context 'when more than 10 image names' do
      let(:provided_names_count) { 15 }

      before do
        expect(subject).to receive(:query_image).with(provided_name).and_return(:image).exactly(10).times
        expect(subject).not_to receive(:random_image_name)
      end

      it 'returns 10 images' do
        expect(subject.retrieve_images.count).to eq(10)
      end
    end

    context 'when no image names' do
      let(:provided_names_count) { 0 }

      before do
        expect(subject).to receive(:random_image_name).and_return(random_name).exactly(10).times
        expect(subject).to receive(:query_image).with(random_name).and_return(:image).exactly(10).times
      end

      it 'returns 10 images' do
        expect(subject.retrieve_images.count).to eq(10)
      end
    end
  end
end
