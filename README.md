Instalation:
* brew install imagemagick
* gem install bundler
* bundle
* gem build collage_maker.gemspec
* gem install collage_maker-1.0.0.gem

Usage Example 1:
* irb
* require 'collage_maker'
* CollageMaker.new.run(*%w(lion waterfall cheetah tiger jaguar peacock snake lizard boomslang parrot jungle))

Usage Example 2:
* uncomment line number 31 in collage_maker.rb
* ruby lib/collage_maker.rb lion waterfall cheetah tiger jaguar peacock snake lizard boomslang parrot jungle
