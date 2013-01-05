require 'pp'

class XPMR
  attr_accessor :values, :colors, :pixels, :bw_colors, :bw_colors_reverse, :bw_pixels
  def initialize(image)
    @image = image
    process
  end

  def process
    @values, @colors, @pixels = eval(@image)

    @bw_colors = {}
    @bw_colors_reverse = {}
    @bw_pixels = []

    @colors.each_with_index do |color, idx|
      @bw_colors[color[0]] = [idx, color[2]]
      @bw_colors_reverse[idx] = color[0]
    end

    @pixels.each do |row|
      row.each_char do |pixel|
        @bw_pixels ||= []
        @bw_pixels << @bw_colors[pixel][0]
      end
    end
  end
end

