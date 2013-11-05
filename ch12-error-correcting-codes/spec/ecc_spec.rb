require 'spec_helper'
require 'ecc'

describe "ECC" do
  before do
    @ecc = ECC.new
    @image = XPMR.new(File.read('./avatar-small.rb'))
  end

  def transmit_to_space(bit_error)
    space_image = @ecc.encode(@image)
    space_image = @ecc.introduce_error(space_image, bit_error)
    @ecc.decode(space_image)
  end

  it "corrects 1 bit of error" do
    fixed_image = transmit_to_space(1)
    expect(@image.bw_pixels).to eql fixed_image
  end

  it "corrects 3 bit of error" do
    fixed_image = transmit_to_space(3)
    expect(@image.bw_pixels).to eql fixed_image
  end

  it "corrects 7 bit of error" do
    fixed_image = transmit_to_space(7)
    expect(@image.bw_pixels).to eql fixed_image
  end

  it "corrects 9 bit of error" do
    fixed_image = transmit_to_space(9)
    expect(@image.bw_pixels).not_to eql fixed_image
  end

  it "corrects 10 bit of error" do
    fixed_image = transmit_to_space(10)
    expect(@image.bw_pixels).not_to eql fixed_image
  end
end
